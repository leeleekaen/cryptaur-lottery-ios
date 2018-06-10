import Foundation
import RxSwift
import RxCocoa
import UInt256
import KeychainSwift

class MyTicketsViewModel: BaseViewModel {
    
    // MARK: - Public properties
    var allActiveTickets: [Ticket] { return activeTickets.values.reduce([Ticket]()) { $0 + $1 } }
    var allPlayedTickets: [Ticket] { return playedTickets.values.reduce([Ticket]()) { $0 + $1 } }
    
    var updateCompletion: (() -> ())?
    
    var winAmount: Driver<UInt256> {
        return winAmountSubject.asDriver(onErrorJustReturn: UInt256(integerLiteral: 0))
    }
    
    // MARK: - Private properties
    private let lotteries: [LotteryID] = [.lottery4x20, .lottery5x36, .lottery6x42]
    
    private var activeTickets: [LotteryID: [Ticket]] = [:]
    private var playedTickets: [LotteryID: [Ticket]] = [:]
    private var isEndOfLottery: [LotteryID: Bool] = [:]
    
    var loadingCount = 0
    
    private let winAmountSubject = BehaviorSubject<UInt256>(value: UInt256(integerLiteral: 0))
    
    // MARK: - Dependency
    private let keychain = KeychainSwift()
    private let winAmountService = GetWinAmountService()
    private let playerTicketsService = GetPlayerTicketsService()
    private let pickUpWinService  = PickUpWinService()
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        reset()
        updateWinAmount()
        getNext()
    }
    
    func reset() {
        activeTickets = [.lottery4x20: [], .lottery5x36: [], .lottery6x42: []]
        playedTickets = [.lottery4x20: [], .lottery5x36: [], .lottery6x42: []]
        isEndOfLottery = [.lottery4x20: false, .lottery5x36: false, .lottery6x42: false]
        loadingCount = 0
        winAmountSubject.onNext(UInt256(integerLiteral: 0))
    }
    
    // MARK: - Get data from server
    func getNext() {
        guard let hexPlayerAddress = keychain.get(PlayersKey.address),
            let playerAddress = UInt256(hexString: hexPlayerAddress) else { return }
        
        lotteries.forEach {
            let activeTicketCount = activeTickets[$0]?.count ?? 0
            let playedTicketCount = playedTickets[$0]?.count ?? 0
            
            guard !isEndOfLottery[$0]! else { return }
            
            updateTickets(playerAddress: playerAddress,
                          lottery: $0,
                          offset: UInt(activeTicketCount) + UInt(playedTicketCount),
                          count: 10)
        }
    }
    
    func pickUpWin() {
        
        guard let authKey = keychain.get(PlayersKey.accessToken),
            let hexAddress = keychain.get(PlayersKey.address),
            let address = UInt256(hexString: hexAddress) else { return }
        
        let request = PickUpWinRequestModel(authKey: authKey,
                                            playerAddress: address)
                
        pickUpWinService.perform(input: request,
                                 success: { (responce) in
                                    print("Success pick up win \(responce)")
            }, failure: defaultServiceFailure)
    }
}

// MARK: - Private methods
private extension MyTicketsViewModel {
    
    func updateTickets(playerAddress: UInt256, lottery: LotteryID, offset: UInt, count: UInt) {
        
        loadingCount += 1
        
        let requestModel = GetPlayerTicketsRequestModel(playerAddress: playerAddress,
                                                        lotteryID: lottery,
                                                        offset: offset,
                                                        count: count)
        
        playerTicketsService.perform(input: requestModel,
                                     success: { [weak self] (responce) in
                                        
                                        guard !responce.tickets.isEmpty else {
                                            self?.isEndOfLottery[lottery] = true
                                            self?.loadingCount -= 1
                                            return
                                        }
                                        
                                        var activeTickets = [Ticket]()
                                        var playedTickets = [Ticket]()
                                        responce.tickets.forEach {
                                            if $0.winLevel == -1 {
                                                activeTickets.append($0)
                                            } else {
                                                playedTickets.append($0)
                                            }
                                        }
                                        
                                        self?.activeTickets[lottery]! += activeTickets
                                        self?.playedTickets[lottery]! += playedTickets
                                        self?.updateCompletion?()
                                        self?.loadingCount -= 1
        }) { [weak self] (error) in
            print("Error for lottery \(lottery): \(error)")
            self?.loadingCount -= 1
        }
    }
    
    func updateWinAmount() {
        
        guard let hexPlayerAddress = keychain.get(PlayersKey.address),
            let playerAddress = UInt256(hexString: hexPlayerAddress) else { return }
        
        winAmountService.perform(input: GetWinAmountRequestModel(playerAddress: playerAddress),
                                 success: { [weak self] (responce) in
                                    self?.winAmountSubject.onNext(responce.winAmount)
            }, failure: defaultServiceFailure)
    }
}
