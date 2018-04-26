import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: BaseViewModel {
    
    let usernameRelay = BehaviorRelay<String?>(value: nil)
    let passwordRelay = BehaviorRelay<String?>(value: nil)
    var loginCompletion: (() -> ())?
    
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
                                               pin: "1234", withPin: false)
        connectTokenService.perform(input: request,
                                    success: { [weak self] (response) in
                                        DispatchQueue.main.async {
                                            self?.loginCompletion?()
                                        }
            }, failure: defaultServiceFailure)
    }
}
