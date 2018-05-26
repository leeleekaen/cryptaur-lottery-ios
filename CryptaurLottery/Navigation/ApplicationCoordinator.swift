import UIKit
import KeychainSwift

enum TransistionType {
    case push(controller: UIViewController)
    case present(controller: UIViewController)
    case setRootWindow(controller: UIViewController)
    case dismiss
    case pop
   // case addNavigation(controller: UIViewController)
}

final class ApplicationCoordinator: CoordinatorDelegate {
    
    func transition(class: BaseViewController, type: TransistionType) {
        
//        func transition (type: TransistionType) {
//            switch type {
//            case .push(let controller):
//                self.navigationController?.pushViewController(controller, animated: true)
//            case .present(let controller):
//                self.window?.rootViewController?.present(controller, animated: true, completion: nil)
//            case .setRootWindow(let controller):
//                UIApplication.shared.keyWindow?.rootViewController = controller
//            case .pop:
//                self.navigationController?.popViewController(animated: true)
//            case .dismiss:
//                self.self.window?.rootViewController?.dismiss(animated: true, completion: nil)
//            }
//        }
        
    }
    
    private var lotteryListViewController: LotteryListViewController = {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let lotteryListViewController = LotteryListViewController.controllerInStoryboard(mainStoryboard)
        return lotteryListViewController
    }()
    
    private var buyTicketContainerViewController: BuyTicketContainerViewController = {
        let buyTicketStoryboard = UIStoryboard(name: "BuyTicketStory", bundle: nil)
        let buyTicketContainerViewController = BuyTicketContainerViewController.controllerInStoryboard(buyTicketStoryboard)
        return buyTicketContainerViewController
    }()
    
//    let menuStoryboard = UIStoryboard(name: "MenuStory", bundle: nil)
//    let menuViewController = MenuViewController.controllerInStoryboard(menuStoryboard)
    
    private weak var window: UIWindow?
    
    private var loginFlowCoordinator: LoginFlowCoordinator?
    
    private let keychain = KeychainSwift()
    
    private var badgeActionCompletion: (() -> ())?
    private var menuActionCompletion: ((_ viewController: BaseViewController) -> ())?

    init(window: UIWindow) {
        self.window = window
        
    }
    func start() {
        configureCompetions()
        startLogin()
    }

    private func startLogin() {
//        loginFlowCoordinator = LoginFlowCoordinator(window: window) { [weak self] in
//            self?.startMain()
//        }
//        //TASK: Without Registering
//        //self.startMain()
//        loginFlowCoordinator?.start()
//
        startMain()
    }

    private func startMain() {
        lotteryListViewController.chooseLotteryCompletion = { [weak self] in
            self?.startBuyTicket(draw: $0)
        }
        lotteryListViewController.delegate = self
        lotteryListViewController.badgeActionCompletion = badgeActionCompletion
        lotteryListViewController.menuActionCompletion = menuActionCompletion
        
        self.window?.rootViewController = BaseNavigationController.createNavBar(viewController: lotteryListViewController)
    }
    
    
    private func startBuyTicket(draw: Draw) {
        buyTicketContainerViewController.draw = draw
        buyTicketContainerViewController.badgeActionCompletion = badgeActionCompletion
        buyTicketContainerViewController.menuActionCompletion = menuActionCompletion
        //navigationController?.pushViewController(buyTicketContainerViewController, animated: true)
    }
    
    private func configureCompetions() {
        
        badgeActionCompletion = { [weak self] in
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let myTicketsViewController = MyTicketsViewController.controllerInStoryboard(mainStoryboard)
            myTicketsViewController.menuActionCompletion = self?.menuActionCompletion
          //  self?.navigationController?.pushViewController(myTicketsViewController, animated: true)
        }
        
        menuActionCompletion = { (viewController) in
            
//            menuViewController.logoutCompletion = { [weak self] in
//                self?.keychain.clear()
//                self?.startLogin()
//            }
//            menuViewController.changePINCompletion = { [weak self] in
//                self?.loginFlowCoordinator?.changePIN()
//            }
//
//            menuViewController.myTicketsCompletion = { [weak self] in
//                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let myTicketsViewController = MyTicketsViewController.controllerInStoryboard(mainStoryboard)
//                myTicketsViewController.menuActionCompletion = self?.menuActionCompletion
//                self?.navigationController?.pushViewController(myTicketsViewController, animated: true)
//            }
//            
//            viewController.present(menuViewController, animated: true, completion: nil)
        }
    }
}
