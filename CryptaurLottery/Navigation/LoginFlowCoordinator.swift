import UIKit
import KeychainSwift

class LoginFlowCoordinator {
    
    private weak var window: UIWindow?
    private let flowCompletion: () -> ()
    
    private let keychain = KeychainSwift()
    
    private var state: State = .getLoginAndPassword
    
    private var username = ""
    private var password = ""
    private var pincode = ""
    
    private var loginViewController: LoginViewController = {
        let storyboard = UIStoryboard(name: "LoginStory", bundle: nil)
        let viewController = LoginViewController.controllerInStoryboard(storyboard)
        return viewController
    }()
    
    private var pinViewController: PinCodeViewController = {
        let storyboard = UIStoryboard(name: "LoginStory", bundle: nil)
        let viewController = PinCodeViewController.controllerInStoryboard(storyboard)
        return viewController
    }()
    
    init(window: UIWindow?, flowCompletion: @escaping () -> ()) {
        self.window = window
        self.flowCompletion = flowCompletion
    }
    
    func start() {
        if keychain.get(PlayersKey.username) != nil {
            state = .loginWithPIN
            startLoginPIN()
        } else {
            state = .getLoginAndPassword
            startLoginPassword()
        }
    }
    
    private func startLoginPassword() {
        
        switch state {
        case .getLoginAndPassword:
            self.window?.rootViewController = loginViewController
        default:
            fatalError("Unexpected state of Login Flow Coordinator")
        }
        
        loginViewController.submitCompletion = { [weak self] (username, password) in
            print("username: \(username), password: \(password)")
            self?.username = username
            self?.password = password
            self?.state = .getFirstPIN
            self?.startLoginPIN()
        }
    }
    
    private func startLoginPIN() {
        
        switch state {
        case .getFirstPIN:
            pinViewController.pincodeCompletion = { [weak self] (pincode) in
                print("first pincode: \(pincode)")
                self?.pincode = pincode
                self?.state = .getSecondPIN
                self?.startLoginPIN()
            }
            pinViewController.enterByLoginCompletion = { [weak self] in
                print("back to login and password")
                self?.username = ""
                self?.password = ""
                self?.pincode = ""
                self?.startLoginPassword()
            }
            loginViewController.present(pinViewController, animated: true, completion: nil)
            pinViewController.configureGetPIN()
        case .getSecondPIN:
            pinViewController.pincodeCompletion = { [weak self] (pincode) in
                print("second pincode: \(pincode)")
                self?.pincode = pincode
            }
            pinViewController.enterByLoginCompletion = { [weak self] in
                print("back to login and password")
                self?.username = ""
                self?.password = ""
                self?.pincode = ""
                self?.startLoginPassword()
            }
            pinViewController.reset()
            
        default:
            fatalError("Unexpected state of Login Flow Coordinator")
        }
    }
}

// MARK: - Embedded type
extension LoginFlowCoordinator {
    enum State {
        case getLoginAndPassword
        case getFirstPIN
        case getSecondPIN
        case loginWithPIN
    }
}
