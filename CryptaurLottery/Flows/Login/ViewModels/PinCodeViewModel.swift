import Foundation
import KeychainSwift

class PinCodeViewModel: BaseViewModel {
    
    // MARK: - Public properties
    var loginCompletion: (() -> ())?
    
    // MARK: - Private properties
    private let username = "a.rytikov@nordavind.ru"
    
    // MARK: - Dependency
    private let connectTokenService = ConnectTokenService()
    
    // MARK: - Submit pin code
    func submit(pincode: String) {
        
        let request = ConnectTokenRequestModel(username: username, password: pincode,
                                               pin: pincode, withPin: true)
        
        connectTokenService.perform(input: request,
                                    success: { [weak self] (response) in
                                        let keychain = KeychainSwift()
                                        keychain.set(request.username,
                                                     forKey: PlayersKey.username)
                                        keychain.set(response.accessToken,
                                                     forKey: PlayersKey.accessToken)
                                        
                                        keychain.set(response.address.normalizedHexString,
                                                     forKey: PlayersKey.address)
                                        DispatchQueue.main.async {
                                            self?.loginCompletion?()
                                        }
            }, failure: defaultServiceFailure)
    }
}
