import UIKit
import KeychainSwift

class LoginFlowCoordinator {
    
    private weak var window: UIWindow?
    private let flowCompletion: () -> ()
    
    private let keychain = KeychainSwift()
    
    init(window: UIWindow?, flowCompletion: @escaping () -> ()) {
        self.window = window
        self.flowCompletion = flowCompletion
    }
    
    func start() {
        if keychain.get(PlayersKey.username) != nil {
            startLoginPIN()
        } else {
            startLoginPassword()
        }
    }
    
    private func startLoginPassword() {
        let loginStoryboard = UIStoryboard(name: "LoginStory", bundle: nil)
        let loginViewController = LoginViewController.controllerInStoryboard(loginStoryboard)
        loginViewController.loginCompletion = flowCompletion
        self.window?.rootViewController = loginViewController
    }
    
    private func startLoginPIN() {
        let loginStoryboard = UIStoryboard(name: "LoginStory", bundle: nil)
        let pinViewController = PinCodeViewController.controllerInStoryboard(loginStoryboard)
        pinViewController.loginCompletion = flowCompletion
        self.window?.rootViewController = pinViewController
    }
}
