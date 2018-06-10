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
    
    fileprivate var timer: Timer?
    var isLoading: Bool = false
    
    override init() {
        super.init()
        getInfoAllLotteries()
    }
}

// MARK: Events
extension LotteryListViewModel {
    func startUpdating() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerFire(_:)),
                                     userInfo: nil, repeats: true)
    }
}

// MARK: Supporting methods
private extension LotteryListViewModel {
    @objc func timerFire(_ sender: Timer) {
        guard !isLoading else {
            return
        }
        getInfoAllLotteries()
    }
}

// MARK: Networking
private extension LotteryListViewModel {
    func getInfoAllLotteries() {
        service.perform(input: (), success: { [weak self] (response) in
            print("api/getCurrentLotteries")
            self?.draws = response.draws
            self?.updateCompletion?()
            }, failure: defaultServiceFailure)
    }
}
