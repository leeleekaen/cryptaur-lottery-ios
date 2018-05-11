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
    
    // MARK: - Private properties
    private let balanceSubject = BehaviorSubject<String>(value: "0.00000000 CPT")
    private let badgeSubject = BehaviorSubject<String>(value: "1")
    private var showAvailableBalance = false
    
    // MARK: - Dependency
    private let buyTicketsService = BuyTicketsService()
    private let balanceService = GetPlayerAviableBalanceService()
    private let playerTicketsService = GetPlayerTicketsService()
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
        badgeSubject.onNext("12")
        badgeActionCompletion?()
    }
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        getBalance()
        updateTickets()
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
    
    func updateTickets() {
        
        guard let hexAddress = keychain.get(PlayersKey.address),
            let playerAddress = UInt256(hexString: hexAddress)  else { return }
        
        LotteryID.allValues.forEach { [weak self] lottery in
            
            let success: (GetPlayerTicketsResponceModel) -> () = { [weak self] (responce) in
                print("Success get \(responce.tickets.count) recent ticket")
            }
            
            let failure: ServiceFailure = { [weak self] (error) in
                print("Error for lottery \(lottery): \(error)")
            }
            
            let requestModel = GetPlayerTicketsRequestModel(playerAddress: playerAddress,
                                                            lotteryID: lottery,
                                                            offset: 0,
                                                            count: 2)
            
            playerTicketsService.perform(input: requestModel,
                                         success: success,
                                         failure: failure)
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
