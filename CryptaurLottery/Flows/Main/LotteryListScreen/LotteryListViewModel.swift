import Foundation
import UInt256
import RxSwift
import RxCocoa

final class LotteryListViewModel: BaseViewModel {
    
    // MARK: - Public properties
    var draws = [Draw]() {
        didSet {
            var amount = UInt256(integerLiteral: 0)
            draws.forEach {
                amount += $0.jackpot
            }
            prizePoolAmountSubject.onNext(amount)
        }
    }
    var updateCompletion: (() -> ())?
    var prizePoolAmount: Driver<UInt256> {
        return prizePoolAmountSubject.asDriver(onErrorJustReturn: UInt256(integerLiteral: 0))
    }
    
    // MARK: - Private properties
    private let prizePoolAmountSubject = BehaviorSubject(value: UInt256(integerLiteral: 0))
    
    private var service = GetCurrentLotteriesService()
    
    override init() {
        super.init()
        
        service.perform(input: (), success: { [weak self] (response) in
            self?.draws = response.draws
            self?.updateCompletion?()
        }, failure: defaultServiceFailure)
    }
}
