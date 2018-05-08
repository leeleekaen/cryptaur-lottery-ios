import UIKit
import KeychainSwift

class LoginFlowCoordinator {
    
    // MARK: - Private properties
    private weak var window: UIWindow?
    private let flowCompletion: () -> ()
    
    private let keychain = KeychainSwift()
    
    private var state: State = .getLoginAndPassword
    
    private var username = ""
    private var password = ""
    private var pincode = ""
    
    // MARK: - View Controllers
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
    
    // MARK: - Dependency
    private let connectTokenService = ConnectTokenService()
    
    // MARK: - Init
    init(window: UIWindow?, flowCompletion: @escaping () -> ()) {
        self.window = window
        self.flowCompletion = flowCompletion
    }
    
    // MARK: - Public methods
    func start() {
        if keychain.get(PlayersKey.username) != nil {
            state = .loginWithPIN
            startLoginPIN()
        } else {
            state = .getLoginAndPassword
            startLoginPassword()
        }
    }
    
    // MARK: - Private methods
    private func startLoginPassword() {
        
        switch state {
        case .getLoginAndPassword:
            self.window?.rootViewController = loginViewController
        case .loginFail(let error):
            DispatchQueue.main.async { [weak self] in
                self?.pinViewController.dismiss(animated: true, completion: nil)
                self?.loginViewController.present(error: error)
            }
        case .pincodeNotMatch:
            DispatchQueue.main.async { [weak self] in
                self?.pinViewController.dismiss(animated: true, completion: nil)
                self?.loginViewController.present(message: "PIN does not match")
            }
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
                self?.pinViewController.reset()
                self?.state = .getSecondPIN
                self?.startLoginPIN()
            }
            loginViewController.present(pinViewController, animated: true, completion: nil)
            pinViewController.configureGetPIN()
            pinViewController.present(message: "Set PIN code")
        case .getSecondPIN:
            pinViewController.pincodeCompletion = { [weak self] (pincode) in
                print("second pincode: \(pincode)")
                if let firstPINcode = self?.pincode, firstPINcode == pincode {
                    self?.submit()
                } else {
                    self?.state = .pincodeNotMatch
                    self?.startLoginPassword()
                }
                self?.pinViewController.reset()
            }
            pinViewController.present(message: "Set PIN code again")
            
        default:
            fatalError("Unexpected state of Login Flow Coordinator")
        }
    }
    
    private func submit() {
        
        let request = ConnectTokenRequestModel(username: username, password: password,
                                               pin: pincode, withPin: false)
        
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
                                            self?.flowCompletion()
                                        }
            }, failure: { [weak self] (error) in
                print(error)
                guard let error = error as? ServiceError else { return }
                self?.state = .loginFail(error)
                self?.startLoginPassword()
        })
    }
}

// MARK: - Embedded type
extension LoginFlowCoordinator {
    enum State {
        case getLoginAndPassword
        case getFirstPIN
        case getSecondPIN
        case loginWithPIN
        case loginFail(ServiceError)
        case pincodeNotMatch
    }
}
