import Foundation
import KeychainSwift
import RxSwift
import RxCocoa

struct PlayersKey {
    static let username = "username"
    static let password = "password"
    static let accessToken = "accessToken"
    static let address = "address"
}

protocol LoginViewModelDelegate: class {
    func showAlertWith(message: String)
}

final class LoginViewModel: BaseViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    
    let usernameRelay = BehaviorRelay<String?>(value: nil)
    let passwordRelay = BehaviorRelay<String?>(value: nil)
    
    private let canSubmitSubject = BehaviorSubject<Bool>(value: false)
    var canSubmit: Driver<Bool> {
        return canSubmitSubject.asDriver(onErrorJustReturn: false)
    }
    
    private let connectTokenService: OperationService<ConnectTokenRequestModel, ConnectTokenResponseModel>
    
    override init() {
        connectTokenService = ConnectTokenService()
        super.init()
        
        usernameRelay.bind { [weak self] (value) in
            let canSubmit: Bool = value?.count ?? 0 > 0 && self?.passwordRelay.value?.count ?? 0 > 0
            self?.canSubmitSubject.onNext(canSubmit)
        }.disposed(by: disposeBag)
        
        passwordRelay.bind { [weak self] (value) in
            let canSubmit: Bool = value?.count ?? 0 > 0 && self?.usernameRelay.value?.count ?? 0 > 0
            self?.canSubmitSubject.onNext(canSubmit)
        }.disposed(by: disposeBag)
    }
    
    func submit() {
        
        guard let username = usernameRelay.value,
            let password = passwordRelay.value else {
            return
        }
        
        let request = ConnectTokenRequestModel(username: username, password: password,
                                               pin: "", withPin: false)
        connectTokenService.perform(input: request,
                                    success: { response in
                                        let keychain = UIApplication.sharedCoordinator.keychain
                                        keychain.set(request.username,
                                                     forKey: PlayersKey.username)
                                        keychain.set(request.password,
                                                     forKey: PlayersKey.password)
                                        keychain.set(response.accessToken,
                                                     forKey: PlayersKey.accessToken)
                                        keychain.set(response.address.normalizedHexString,
                                                     forKey: PlayersKey.address)
                                        DispatchQueue.main.async {
                                            UIApplication.sharedCoordinator.showPin(flow: .setPin, exitType: .defaultPin)
                                        }
            }, failure: defaultServiceFailure)
    }
}
