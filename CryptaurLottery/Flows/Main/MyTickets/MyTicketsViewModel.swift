import Foundation
import RxSwift
import RxCocoa
import UInt256

class MyTicketsViewModel: BaseViewModel {
    
    // MARK: - Public properties
    var activeTickets = [Ticket]() {
        didSet {
            print("number of tickets \(activeTickets.count)")
        }
    }
    var playedTickets = [Ticket]()
    var winAmount: Driver<UInt256> {
        return winAmountSubject.asDriver(onErrorJustReturn: UInt256(integerLiteral: 0))
    }
    
    
    // MARK: - Private properties
    private let lotteries: [LotteryID] = [.lottery4x20, .lottery5x36, .lottery6x42]
    private let playerAddress = UInt256(hexString: "0x14f05a4593ee1808541525a5aa39e344381251e6")!
    private let winAmountSubject = BehaviorSubject<UInt256>(value: UInt256(integerLiteral: 0))
    private let activeTicketsUpdaterSubject = BehaviorSubject<[Ticket]>(value: [])
    private var activeTicketUpdater: Driver<[Ticket]> {
        return activeTicketsUpdaterSubject.asDriver(onErrorJustReturn: [])
    }
    
    // MARK: - Dependency
    private let winAmountService = GetWinAmountService()
    private let playerTicketsService = GetPlayerTicketsService()
    private let pickUpWinService  = PickUpWinService()
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        
        activeTicketUpdater.drive(onNext: { [weak self] (tickets) in
            print("add new tickets")
            self?.activeTickets += tickets
        }).disposed(by: disposeBag)
        
        updateTickets(for: playerAddress, and: lotteries[0])
        updateTickets(for: playerAddress, and: lotteries[1])
        updateTickets(for: playerAddress, and: lotteries[2])
    }
    
    func pickUpWin(for playerAddress: UInt256, witjKey key: String) {
        
        pickUpWinService.perform(input: PickUpWinRequestModel(authKey: key, playerAddress: playerAddress),
                                 success: { (responce) in
                                    print("Success pick up win \(responce)")
            }, failure: defaultServiceFailure)
    }
    
    func update(for playerAddress: UInt256, and lotteries: [LotteryID]) {
        
        updateWinAmount(for: playerAddress)
        updateTickets(for: playerAddress, and: lotteries.first!)
    }
    
    private func updateWinAmount(for playerAddress: UInt256) {
        
        winAmountService.perform(input: GetWinAmountRequestModel(playerAddress: playerAddress),
                        success: { [weak self] (responce) in
                            self?.winAmountSubject.onNext(responce.winAmount)
            }, failure: defaultServiceFailure)
    }
    
    private func updateTickets(for playerAddress: UInt256, and lottery: LotteryID) {
        
        print("Start update tickets for lottery: \(lottery)")
        let requestModel = GetPlayerTicketsRequestModel(playerAddress: playerAddress,
                                                        lotteryID: lottery)
        
        playerTicketsService.perform(input: requestModel,
                                     success: { [weak self] (responce) in
                                        print("succes respond count: \(responce.tickets.count)")
                                        self?.activeTicketsUpdaterSubject.onNext(responce.tickets)
        }) { (error) in
            print("Error: \(error)")
        }
        
//        playerTicketsService.perform(input: requestModel, success: { (responce) in
//            print(responce)
//        }, failure: defaultServiceFailure)
    }
}
