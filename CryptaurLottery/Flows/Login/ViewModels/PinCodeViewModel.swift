import Foundation
import KeychainSwift

class PinCodeViewModel: BaseViewModel {
    
    // MARK: - Public properties
    
    // MARK: - Private properties
    private let keychain = KeychainSwift()
    // MARK: - Dependency
    private let connectTokenService = ConnectTokenService()
    
    // MARK: - Submit pin code
    func submit(pincode: String) {
        guard let username = keychain.get(PlayersKey.username) else {
            return
            //TODO: fatalError
        }
        
        let request = ConnectTokenRequestModel(username: username, password: pincode,
                                               pin: pincode, withPin: true)
        
        connectTokenService.perform(input: request,
                                    success: { [weak self] response in
                                        self?.keychain.set(request.username,
                                                           forKey: PlayersKey.username)
                                        self?.keychain.set(response.accessToken,
                                                           forKey: PlayersKey.accessToken)
                                        self?.keychain.set(response.address.normalizedHexString,
                                                           forKey: PlayersKey.address)
                                        DispatchQueue.main.async {
                                            UIApplication.sharedCoordinator.showAuth()
                                        }
            }, failure: defaultServiceFailure)
        
    }
    
    func registerPin(pincode: String) {
        guard let username = keychain.get(PlayersKey.username),
            let password = keychain.get(PlayersKey.password) else {
            return
            //TODO: fatalError
        }
        let request = ConnectTokenRequestModel(username: username, password: password,
                                               pin: pincode, withPin: false)
        connectTokenService.perform(input: request,
                                    success: { [weak self] response in
                                        self?.keychain.set(request.username,
                                                     forKey: PlayersKey.username)
                                        self?.keychain.set(request.password,
                                                     forKey: PlayersKey.password)
                                        self?.keychain.set(response.accessToken,
                                                     forKey: PlayersKey.accessToken)
                                        self?.keychain.set(response.address.normalizedHexString,
                                                     forKey: PlayersKey.address)
                                        DispatchQueue.main.async {
                                            UIApplication.sharedCoordinator.showAuth()
                                        }
        }, failure: defaultServiceFailure)
    }
}
