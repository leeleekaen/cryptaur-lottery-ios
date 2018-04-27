import RxSwift
import RxCocoa
import UInt256
import KeychainSwift

protocol BalanceViewModelProtocol {
    var balance: Driver<String> { get }
    func purseAction()
    func balanceAction()
}

final class BalanceViewModel: BaseViewModel, BalanceViewModelProtocol, BadgeViewModelProtocol {
    
    // MARK: - Public properties
    var balance: Driver<String> {
        return balanceSubject.asDriver(onErrorJustReturn: "")
    }
    
    // MARK: - Private properties
    private let balanceSubject = BehaviorSubject<String>(value: "0.00000000 CPT")
    private let badgeSubject = BehaviorSubject<String>(value: "1")
    private var showAvailableBalance = false
    
    // MARK: - Dependency
    let buyTicketsService = BuyTicketsService()
    let balanceService = GetPlayerAviableBalanceService()
    let keychain = KeychainSwift()
    
    func purseAction() {
    }
    
    func balanceAction() {
    }

    var badge: Driver<String> {
        return badgeSubject.asDriver(onErrorJustReturn: "")
    }
    
    func badgeAction() {
        badgeSubject.onNext("12")
    }
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        
        if let hexAddress = keychain.get("address"), let address = UInt256(hexString: hexAddress) {
            getBalance(playerAddress: address)
        }
    }
}

// MARK: - Private methods
private extension BalanceViewModel {
    
    func getBalance(playerAddress: UInt256) {
        
        let request = GetPlayerAviableBalanceRequestModel(address: playerAddress)
        
        balanceService.perform(input: request,
                               success: { [weak self] (responce) in
                                var balance = responce.balance.toStringWithDelimeters()
                                if responce.balance != UInt256(integerLiteral: 0) {
                                    balance.removeLast(5)
                                }
                                self?.balanceSubject.onNext(balance + " CPT")
            }, failure: defaultServiceFailure)
    }
}

extension Bool {
    @discardableResult
    mutating func toggle() -> Bool {
        self = !self
        return self
    }
}
