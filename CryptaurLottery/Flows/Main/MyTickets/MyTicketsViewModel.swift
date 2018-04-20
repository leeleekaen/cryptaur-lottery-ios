import Foundation
import RxSwift
import RxCocoa
import UInt256

class MyTicketsViewModel: BaseViewModel {
    
    private let winAmountSubject = BehaviorSubject<UInt256>(value: UInt256(integerLiteral: 0))
    var winAmount: Driver<UInt256> {
        return winAmountSubject.asDriver(onErrorJustReturn: UInt256(integerLiteral: 0))
    }
    
    private let winAmountService = GetWinAmountService()
    private let playerTicketsService = GetPlayerTicketsService()
    
    override init() {
        super.init()
    }
    
    func update(for playerAddress: UInt256, and lotteries: [LotteryID]) {
        
        updateWinAmount(for: playerAddress)
        updateTickets(for: playerAddress, and: lotteries)
    }
    
    private func updateWinAmount(for playerAddress: UInt256) {
        
        winAmountService.perform(input: GetWinAmountRequestModel(playerAddress: playerAddress),
                        success: { [weak self] (responce) in
                            self?.winAmountSubject.onNext(responce.winAmount)
            }, failure: defaultServiceFailure)
    }
    
    private func updateTickets(for playerAddress: UInt256, and lotteries: [LotteryID]) {
        
        let requestModel = GetPlayerTicketsRequestModel(playerAddress: playerAddress,
                                                        lotteryID: lotteries.first!)
        
        playerTicketsService.perform(input: requestModel, success: { (responce) in
            print(responce)
        }, failure: defaultServiceFailure)
    }
}
