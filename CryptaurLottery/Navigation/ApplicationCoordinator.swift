import UIKit
import KeychainSwift

//enum TransistionType {
//    case push(controller: UIViewController)
//    case present(controller: UIViewController)
//    case setRootWindow(controller: UIViewController)
//    case dismiss
//    case pop
//   // case addNavigation(controller: UIViewController)
//}

enum TransistionType {
    case push(controller: UIViewController)
    case present(controller: UIViewController, completion: (() -> Void)?)
    case setRootWindow(controller: UIViewController)
    case dismiss(completion: (() -> Void)?)
    case pop
}


enum TransistionVC {
    case lotteryListViewController
    case buyTicketContainerViewController
    case menuViewController
    case myTicketsViewController
    
    var value: String {
        switch self {
        case .lotteryListViewController:
            return "LotteryListViewController"
        case .buyTicketContainerViewController:
            return "BuyTicketContainerViewController"
        case .menuViewController:
            return "MenuViewController"
        case .myTicketsViewController:
            return "MyTicketsViewController"
        }
    }
}

enum StoryboardType {
    case main
    case buyTicketStory
    case menuStory
    case login
    
    var name: String {
        switch self {
        case .main:
            return "Main"
        case .buyTicketStory:
            return "BuyTicketStory"
        case .menuStory:
            return "MenuStory"
        case .login:
            return "LoginStory"
        }
    }
}

final class ApplicationCoordinator {
    
    var navigationController: BaseNavigationController?
    
    func addVcNavigationController(vc: UIViewController) {
        navigationController = BaseNavigationController()
        navigationController?.viewControllers = [vc]
    }
    
    private weak var window: UIWindow?
    private var childCoordinator: ChildCoordinator? {
        didSet {
            childCoordinator?.start()
        }
    }
    
    private let keychain = KeychainSwift()

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
            if let currentController = navigationController?.topViewController,
                object_getClassName(currentController) == object_getClassName(controller) {
                return false
            }
            return true
        }
        
        switch type {
        case .push(let controller):
            if isNeedShow(controller: controller) {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        case .present(let controller, let completion):
            if isNeedShow(controller: controller) {
                self.window?.rootViewController?.present(controller, animated: true, completion: completion)
            }
        case .setRootWindow(let controller):
            UIApplication.shared.keyWindow?.rootViewController = controller
        case .pop:
            self.navigationController?.popViewController(animated: true)
        case .dismiss(let completion):
            self.window?.rootViewController?.dismiss(animated: true, completion: completion)
        }
    }
}
