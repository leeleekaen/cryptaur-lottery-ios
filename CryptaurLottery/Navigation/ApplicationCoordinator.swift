import UIKit
import KeychainSwift

final class ApplicationCoordinator {
    
    var navigationController = BaseNavigationController()
    
    private weak var window: UIWindow?
    private var childCoordinator: ChildCoordinator? {
        didSet {
            childCoordinator?.start()
        }
    }
    
    let keychain = KeychainSwift()

    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        if keychain.get(PlayersKey.username) != nil {
            showPin(flow: .askPin)
        } else {
            showUnauth()
        }
    }
    
    //LoginPassword
    func showUnauth() {
        childCoordinator = UnathorizedFlowCoordinator(rootCoordinator: self)
    }
    //Show Pin
    func showPin(flow: PinCodeViewController.Flow) {
        let child = SetPinFlowCoordinator(rootCoordinator: self)
        child.pinControllerFlow = flow
        childCoordinator = child
    }
    //Main meny List
    func showAuth() {
        childCoordinator = AuthorizedFlowCoordinator(rootCoordinator: self)
    }
    
    func transition(type: TransistionType) {
        func isNeedShow(controller: UIViewController) -> Bool {
            if let currentController = navigationController.topViewController,
                object_getClassName(currentController) == object_getClassName(controller) {
                return false
            }
            return true
        }
        
        switch type {
        case .push(let controller):
            if isNeedShow(controller: controller) {
                self.navigationController.pushViewController(controller, animated: true)
            }
        case .present(let controller, let completion):
            if isNeedShow(controller: controller) {
                self.window?.rootViewController?.present(controller, animated: true, completion: completion)
            }
        case .setRootWindow(let controller):
            UIApplication.shared.keyWindow?.setRootViewController(controller, options: UIWindow.TransitionOptions(direction: UIWindow.TransitionOptions.Direction.toTop, style: UIWindow.TransitionOptions.Curve.linear))
        case .pop:
            self.navigationController.popViewController(animated: true)
        case .dismiss(let completion):
            self.window?.rootViewController?.dismiss(animated: true, completion: completion)
        }
    }
}
