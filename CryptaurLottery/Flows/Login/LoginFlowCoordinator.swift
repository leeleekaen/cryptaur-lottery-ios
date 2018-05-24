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
        if let username = keychain.get(PlayersKey.username) {
            self.username = username
            state = .loginWithPIN
            startLoginPIN()
        } else {
            state = .getLoginAndPassword
            startLoginPassword()
        }
    }
    
    func changePIN() {
        print("Change PIN flow")
        state = .changePIN
        startLoginPassword()
    }
    
    
    // MARK: - Private methods
    
    private func changePinCode(secondChange: Bool) {
        
        pinViewController.pincodeCompletion = { [weak self] (pincode) in
            self?.pincode = pincode
            self?.pinViewController.reset()
            self?.state = .getSecondPIN
            self?.startLoginPIN()
        }
        if (!secondChange) {
            loginViewController.present(pinViewController, animated: true, completion: nil)
        }
        pinViewController.configureGetPIN()
        pinViewController.present(message: "Set PIN code")
    }
    
    private func startLoginPassword() {
        
        switch state {
        case .getLoginAndPassword:
            self.window?.rootViewController = loginViewController
            pinViewController.exitButtonCompletion = { [weak self]  in
               self?.pinViewController.dismiss(animated: true, completion: nil)
            }
        case .loginByPasswordFail(let error):
            DispatchQueue.main.async { [weak self] in
                self?.pinViewController.dismiss(animated: true, completion: nil)
                self?.loginViewController.present(error: error)
            }
        case .pincodeNotMatch:
            DispatchQueue.main.async { [weak self] in
                self?.pinViewController.dismiss(animated: true, completion: nil)
                self?.loginViewController.present(message: "PIN does not match")
            }
        case .loginByPINFail(let error):
            DispatchQueue.main.async { [weak self] in
                self?.pinViewController.dismiss(animated: true, completion: nil)
                self?.window?.rootViewController = self?.loginViewController
                self?.loginViewController.present(error: error)
            }
        case .changePIN:
            
            guard let username = keychain.get(PlayersKey.username),
                let password = keychain.get(PlayersKey.password) else { break }
            self.window?.rootViewController = pinViewController
    
            self.username = username
            self.password = password
            
            self.changePinCode(secondChange: true)
            pinViewController.exitButtonCompletion = { [weak self]  in
                self?.flowCompletion()
            }
            
            
            print("passport: \(password)")
            
        default:
            fatalError("Unexpected state of Login Flow Coordinator")
        }
        
        loginViewController.submitCompletion = { [weak self] (username, password) in
            self?.username = username
            self?.password = password
            self?.state = .getFirstPIN
            self?.startLoginPIN()
        }
        
        //TASK: Button Exit
        
    }
    
    private func startLoginPIN() {
        
        switch state {
        case .getFirstPIN:
            
            self.changePinCode(secondChange: false)
            
        case .getSecondPIN:
            pinViewController.pincodeCompletion = { [weak self] (pincode) in
                if let firstPINcode = self?.pincode, firstPINcode == pincode {
                    self?.submitByPassword()
                } else {
                    self?.state = .pincodeNotMatch
                    self?.startLoginPassword()
                }
                self?.pinViewController.reset()
            }
            pinViewController.present(message: "Set PIN code again")
        case .loginWithPIN:
            pinViewController.pincodeCompletion = { [weak self] (pincode) in
                self?.pincode = pincode
                self?.pinViewController.reset()
                self?.submitByPIN()
            }
            self.window?.rootViewController = pinViewController
        default:
            fatalError("Unexpected state of Login Flow Coordinator")
        }
    }
    
    private func submitByPassword() {
        
        let request = ConnectTokenRequestModel(username: username, password: password,
                                               pin: pincode, withPin: false)
        print(request)
        
        connectTokenService.perform(input: request,
                                    success: { [weak self] (response) in
                                        let keychain = KeychainSwift()
                                        keychain.set(request.username,
                                                     forKey: PlayersKey.username)
                                        keychain.set(request.password,
                                                     forKey: PlayersKey.password)
                                        keychain.set(response.accessToken,
                                                     forKey: PlayersKey.accessToken)
                                        keychain.set(response.address.normalizedHexString,
                                                     forKey: PlayersKey.address)
                                        DispatchQueue.main.async {
                                            self?.flowCompletion()
                                        }
            }, failure: { [weak self] (error) in
                guard let error = error as? ServiceError else { return }
                self?.state = .loginByPasswordFail(error)
                self?.startLoginPassword()
        })
    }
    
    private func submitByPIN() {
        
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
                                            self?.flowCompletion()
                                        }
            }, failure: { [weak self] (error) in
                guard let error = error as? ServiceError else { return }
                self?.state = .loginByPINFail(error)
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
        case loginByPasswordFail(ServiceError)
        case loginByPINFail(ServiceError)
        case pincodeNotMatch
        case changePIN
        
    }
}
