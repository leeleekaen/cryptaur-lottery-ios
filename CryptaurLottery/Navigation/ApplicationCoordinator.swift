import UIKit
import KeychainSwift

final class ApplicationCoordinator {
    
    private weak var window: UIWindow?
    private var navigationController: BaseNavigationController?
    
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
        if keychain.get(PlayersKey.username) != nil {
            startLoginPIN()
        } else {
            startLoginPassword()
        }
    }
    
    private func startLoginPassword() {
        let loginStoryboard = UIStoryboard(name: "LoginStory", bundle: nil)
        let loginViewController = LoginViewController.controllerInStoryboard(loginStoryboard)
        loginViewController.setFlowCompletion { [weak self] in
            self?.startMain()
        }
        self.window?.rootViewController = loginViewController
    }
    
    private func startLoginPIN() {
        let loginStoryboard = UIStoryboard(name: "LoginStory", bundle: nil)
        let pinViewController = PinCodeViewController.controllerInStoryboard(loginStoryboard)
        pinViewController.setFlowCompletion { [weak self] in
            self?.startMain()
        }
        self.window?.rootViewController = pinViewController
    }

    private func startMain() {
        
        navigationController = BaseNavigationController()
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

        let lotteryListViewController = LotteryListViewController.controllerInStoryboard(mainStoryboard)
        
        lotteryListViewController.chooseLotteryCompletion = { [weak self] in
            self?.startBuyTicket(lottery: $0)
        }
        lotteryListViewController.badgeActionCompletion = badgeActionCompletion
        lotteryListViewController.menuActionCompletion = menuActionCompletion
        
        navigationController?.viewControllers = [lotteryListViewController]
        self.window?.rootViewController = navigationController
    }
    
    private func startBuyTicket(lottery: LotteryID) {
        let buyTicketStoryboard = UIStoryboard(name: "BuyTicketStory", bundle: nil)
        let buyTicketContainerViewController = BuyTicketContainerViewController.controllerInStoryboard(buyTicketStoryboard)
        buyTicketContainerViewController.lottery = lottery
        buyTicketContainerViewController.badgeActionCompletion = badgeActionCompletion
        buyTicketContainerViewController.menuActionCompletion = menuActionCompletion
        navigationController?.pushViewController(buyTicketContainerViewController, animated: true)
    }
    
    private func configureCompetions() {
        
        badgeActionCompletion = { [weak self] in
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let myTicketsViewController = MyTicketsViewController.controllerInStoryboard(mainStoryboard)
            myTicketsViewController.menuActionCompletion = self?.menuActionCompletion
            self?.navigationController?.pushViewController(myTicketsViewController, animated: true)
        }
        
        menuActionCompletion = { (viewController) in
            let menuStoryboard = UIStoryboard(name: "MenuStory", bundle: nil)
            let menuViewController = MenuViewController.controllerInStoryboard(menuStoryboard)
            
            menuViewController.logoutCompletion = { [weak self] in
                self?.keychain.clear()
                self?.startLogin()
            }
            
            viewController.present(menuViewController, animated: true, completion: nil)
        }
    }
}
