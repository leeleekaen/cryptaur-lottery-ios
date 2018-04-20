import Foundation
import RxSwift
import RxCocoa
import UInt256

class MyTicketsViewModel: BaseViewModel {
    
    private let winAmountSubject = BehaviorSubject<UInt256>(value: UInt256(integerLiteral: 0))
    var winAmount: Driver<UInt256> {
        return winAmountSubject.asDriver(onErrorJustReturn: UInt256(integerLiteral: 0))
    }
    
    override init() {
        super.init()
        
        winAmountSubject.onNext(UInt256(hexString: "0x203040")!)
    }
}
