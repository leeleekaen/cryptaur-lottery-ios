import Foundation
import RxSwift
import RxCocoa
import UInt256

class MyTicketsViewModel: BaseViewModel {
    
    var activeTickets = [Ticket]()
    var playedTickets = [Ticket]()
    
//    private let activeTicketsSubject = BehaviorSubject<[Ticket]>(value: [])
//    var activeTickets: Driver<[Ticket]> {
//        return activeTicketsSubject.asDriver(onErrorJustReturn: [])
//    }
//
//    private let playedTicketsSubject = BehaviorSubject<[Ticket]>(value: [])
//    var playedTickets: Driver<[Ticket]> {
//        return playedTicketsSubject.asDriver(onErrorJustReturn: [])
//    }
    
    private let winAmountSubject = BehaviorSubject<UInt256>(value: UInt256(integerLiteral: 0))
    var winAmount: Driver<UInt256> {
        return winAmountSubject.asDriver(onErrorJustReturn: UInt256(integerLiteral: 0))
    }
    
    private let winAmountService = GetWinAmountService()
    private let playerTicketsService = GetPlayerTicketsService()
    private let pickUpWinService  = PickUpWinService()
    
    override init() {
        super.init()
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
        
        let requestModel = GetPlayerTicketsRequestModel(playerAddress: playerAddress,
                                                        lotteryID: lottery)
        
        playerTicketsService.perform(input: requestModel, success: { (responce) in
            print(responce)
            
        }, failure: defaultServiceFailure)
    }
}
