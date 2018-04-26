import Foundation

class PinCodeViewModel: BaseViewModel {
    
    // MARK: - Public properties
    var loginCompletion: (() -> ())?
    
    // MARK: - Private properties
    private let username = "a.rytikov@nordavind.ru"
    private let pin = "1234"
    
    // MARK: - Dependency
    private let connectTokenService = ConnectTokenService()
    
    // MARK: - Submit pin code
    func submit() {
        
        let request = ConnectTokenRequestModel(username: username, password: pin,
                                               pin: pin, withPin: true)
        
        connectTokenService.perform(input: request,
                                    success: { [weak self] (response) in
                                        print(response)
                                        DispatchQueue.main.async {
                                            self?.loginCompletion?()
                                        }
            }, failure: defaultServiceFailure)
    }
}
