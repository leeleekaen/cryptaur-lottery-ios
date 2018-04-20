import Foundation
import RxSwift
import RxCocoa

class MyTicketsViewModel: BaseViewModel {
    
    private let winAmountSubject = BehaviorSubject<WinAmount>(value: WinAmount())
    var winAmount: Driver<WinAmount> {
        return winAmountSubject.asDriver(onErrorJustReturn: WinAmount())
    }
    
    override init() {
        super.init()
        
        let json = getWinAmountJson()
        winAmountSubject.onNext(WinAmount(json: json)!)
    }
    
    private func getWinAmountJson() -> JSONDictionary {
        return ["winAmount": "0x203040",
                "pickUpWinGasFee": "0x003040"]
    }
}
