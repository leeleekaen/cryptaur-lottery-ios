import RxSwift
import RxCocoa
import UInt256
import KeychainSwift

protocol BalanceViewModelProtocol {
    var balance: Driver<String> { get }
    func purseAction()
    func balanceAction()
}

final class BalanceViewModel: BaseViewModel, BalanceViewModelProtocol, BadgeViewModelProtocol {
    
    // MARK: - Public properties
    var balance: Driver<String> {
        return balanceSubject.asDriver(onErrorJustReturn: "")
    }
    var badgeActionCompletion:(() -> ())?
    var updateCompletion: (() -> ())?
    
    // MARK: - Private properties
    private let balanceSubject = BehaviorSubject<String>(value: "0.00000000 CPT")
    private let badgeSubject = BehaviorSubject<String>(value: "0")
    private var showAvailableBalance = false
    
    private var lastPlayedDraws = [LotteryID: Int]()
    
    private var loadingDrawsCount = 0 {
        didSet {
            if loadingDrawsCount == 0 {
                getNext()
            }
        }
    }
    
    private var loadedTickets: [LotteryID: [Ticket]] = [
        .lottery4x20: [], .lottery5x36: [], .lottery6x42: []
        ] {
        didSet {
            let sum = loadedTickets[.lottery4x20]!.count + loadedTickets[.lottery5x36]!.count + loadedTickets[.lottery6x42]!.count
            badgeSubject.onNext("\(sum)")
        }
    }
    
    private var isEndOfLottery: [LotteryID: Bool] = [
        .lottery4x20: false, .lottery5x36: false, .lottery6x42: false
    ]
    
    // MARK: - Dependency
    private let buyTicketsService = BuyTicketsService()
    private let balanceService = GetPlayerAviableBalanceService()
    private let playerTicketsService = GetPlayerTicketsService()
    private let getDrawService = GetDrawsService()
    let keychain = KeychainSwift()
    
    func purseAction() {
        getBalance()
    }
    
    func balanceAction() {
        getBalance()
    }

    var badge: Driver<String> {
        return badgeSubject.asDriver(onErrorJustReturn: "")
    }
    
    func badgeAction() {
//        badgeActionCompletion?()
    }
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        getBalance()
        getDraws()
    }
}

// MARK: - Private methods
private extension BalanceViewModel {
    
    func getBalance() {
        
        guard let hexAddress = keychain.get(PlayersKey.address),
            let playerAddress = UInt256(hexString: hexAddress)  else { return }
        
        let request = GetPlayerAviableBalanceRequestModel(address: playerAddress)
        
        balanceService.perform(input: request,
                               success: { [weak self] (responce) in
                                var balance = responce.balance.toStringWithDelimeters()
                                if responce.balance != UInt256(integerLiteral: 0) {
                                    balance.removeLast(5)
                                }
                                self?.balanceSubject.onNext(balance + " CPT")
            }, failure: defaultServiceFailure)
    }
    
    func getDraws() {
        
        LotteryID.allValues.forEach { [weak self] lottery in
            
            loadingDrawsCount += 1
            
            let request = GetDrawsRequestModel(lotteryID: lottery, offset: 0, count: 2)
            
            let success: (GetDrawsResponceModel) -> () = { [weak self] responce in
                
                if let draw = responce.draws.first, draw.drawState == .played {
                    self?.lastPlayedDraws[lottery] = draw.number
                    self?.loadingDrawsCount -= 1
                    return
                }
                
                if let draw = responce.draws.last, draw.drawState == .played {
                    self?.lastPlayedDraws[lottery] = draw.number
                    self?.loadingDrawsCount -= 1
                    return
                }
                
                self?.loadingDrawsCount -= 1
            }
            
            let failure: ServiceFailure = { [weak self] (error) in
                print("Error for lottery \(lottery): \(error)")
            }
            
            getDrawService.perform(input: request,
                                   success: success,
                                   failure: failure)
        }
    }
    
    func getNext() {
        
        guard let hexPlayerAddress = keychain.get(PlayersKey.address),
            let playerAddress = UInt256(hexString: hexPlayerAddress) else { return }
        
        LotteryID.allValues.forEach {

            let loadedTicketsCount = loadedTickets[$0]?.count ?? 0
            
            guard !isEndOfLottery[$0]! else { return }
            
            updateTickets(playerAddress: playerAddress,
                          lottery: $0,
                          offset: UInt(loadedTicketsCount),
                          count: 10)
        }
    }
    
    func updateTickets(playerAddress: UInt256, lottery: LotteryID, offset: UInt, count: UInt) {
        
        let requestModel = GetPlayerTicketsRequestModel(playerAddress: playerAddress,
                                                        lotteryID: lottery,
                                                        offset: offset,
                                                        count: count)
        
        playerTicketsService.perform(input: requestModel,
                                     success: { [weak self] (responce) in

                                        guard !responce.tickets.isEmpty else {
                                            self?.isEndOfLottery[lottery] = true
                                            return
                                        }

                                        guard let lastPlayedDrawIndex = self?.lastPlayedDraws[lottery] else {
                                            print("No last played draw for lottery: \(lottery)")
                                            return
                                        }

                                        var loadedTickets = [Ticket]()
                                        responce.tickets.forEach {
                                            if $0.drawIndex == lastPlayedDrawIndex {
                                                loadedTickets.append($0)
                                            }
                                        }

                                        self?.loadedTickets[lottery]! += loadedTickets
                                        self?.updateCompletion?()
        }) { [weak self] (error) in
            print("Error for lottery \(lottery): \(error)")
        }
    }
}

extension Bool {
    @discardableResult
    mutating func toggle() -> Bool {
        self = !self
        return self
    }
}
