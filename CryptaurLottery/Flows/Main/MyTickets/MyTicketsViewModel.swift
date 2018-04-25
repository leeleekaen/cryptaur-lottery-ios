import Foundation
import RxSwift
import RxCocoa
import UInt256

class MyTicketsViewModel: BaseViewModel {
    
    // MARK: - Public properties
    var allActiveTickets: [Ticket] { return activeTickets.values.reduce([Ticket]()) { $0 + $1 } }
    var allPlayedTickets: [Ticket] { return playedTickets.values.reduce([Ticket]()) { $0 + $1 } }
    
    var updateCompletion: (() -> ())?
    var isLoading: Driver<Bool> {
        return isLoadingSubject.asDriver(onErrorJustReturn: false)
    }
    
    var winAmount: Driver<UInt256> {
        return winAmountSubject.asDriver(onErrorJustReturn: UInt256(integerLiteral: 0))
    }
    
    // MARK: - Private properties
    private let lotteries: [LotteryID] = [.lottery4x20, .lottery5x36, .lottery6x42]
    private let playerAddress = UInt256(hexString: "0x14f05a4593ee1808541525a5aa39e344381251e6")!
    
    private var activeTickets: [LotteryID: [Ticket]] = [.lottery4x20: [], .lottery5x36: [], .lottery6x42: []]
    private var playedTickets: [LotteryID: [Ticket]] = [.lottery4x20: [], .lottery5x36: [], .lottery6x42: []]
    
    private var loadingCount = 0 {
        didSet {
            if loadingCount == 0 {
                isLoadingSubject.onNext(false)
            } else {
                isLoadingSubject.onNext(true)
            }
        }
    }
    private let isLoadingSubject = BehaviorSubject<Bool>(value: false)
    
    private let winAmountSubject = BehaviorSubject<UInt256>(value: UInt256(integerLiteral: 0))
    
    // MARK: - Dependency
    private let winAmountService = GetWinAmountService()
    private let playerTicketsService = GetPlayerTicketsService()
    private let pickUpWinService  = PickUpWinService()
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        updateWinAmount(for: playerAddress)
        getNext()
    }
    
    // MARK: - Get data from server
    func getNext() {
        
        lotteries.forEach {
            let activeTicketCount = activeTickets[$0]?.count ?? 0
            let playedTicketCount = playedTickets[$0]?.count ?? 0
            updateTickets(playerAddress: playerAddress,
                          lottery: $0,
                          offset: UInt(activeTicketCount) + UInt(playedTicketCount),
                          count: 5)
        }
    }
    
    func pickUpWin(for playerAddress: UInt256, witjKey key: String) {
        
        pickUpWinService.perform(input: PickUpWinRequestModel(authKey: key, playerAddress: playerAddress),
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
                                        print("succes respond for \(lottery) count: \(responce.tickets.count)")
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
    
    func updateWinAmount(for playerAddress: UInt256) {
        
        winAmountService.perform(input: GetWinAmountRequestModel(playerAddress: playerAddress),
                                 success: { [weak self] (responce) in
                                    self?.winAmountSubject.onNext(responce.winAmount)
            }, failure: defaultServiceFailure)
    }
}
