//
//  ApplicationCoordinator.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 19.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit

final class ApplicationCoordinator {
    
    private weak var window: UIWindow?
    private var navigationController: BaseNavigationController?
    
    private var badgeActionCompletion: (() -> ())?
    private var menuActionCompletion: ((_ viewController: BaseViewController) -> ())?

    init(window: UIWindow) {
        self.window = window
    }

    func startLogin() {
        
        configureCompetions()

        let loginStoryboard = UIStoryboard(name: "LoginStory", bundle: nil)
        let loginViewController = LoginViewController.controllerInStoryboard(loginStoryboard)
        loginViewController.setFlowCompletion { [weak self] in
            self?.startMain()
        }
       self.window?.rootViewController = loginViewController

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
                self?.startLogin()
            }
            
            viewController.present(menuViewController, animated: true, completion: nil)
        }
    }
}
