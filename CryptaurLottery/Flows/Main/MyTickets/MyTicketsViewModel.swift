import Foundation
import RxSwift
import RxCocoa
import UInt256

class MyTicketsViewModel: BaseViewModel {
    
    private let winAmountSubject = BehaviorSubject<UInt256>(value: UInt256(integerLiteral: 0))
    var winAmount: Driver<UInt256> {
        return winAmountSubject.asDriver(onErrorJustReturn: UInt256(integerLiteral: 0))
    }
    
    private let service = GetWinAmountService()
    
    override init() {
        super.init()
    }
    
    func updateWinAmount(for playerAddress: UInt256) {
        
        service.perform(input: GetWinAmountRequestModel(playerAddress: playerAddress),
                        success: { [weak self] (responce) in
                            self?.winAmountSubject.onNext(responce.winAmount)
            }, failure: defaultServiceFailure)
    }
}
