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
    private let navigationController = BaseNavigationController()

    init(window: UIWindow) {
        self.window = window
    }

    func start() {

        let loginStoryboard = UIStoryboard(name: "LoginStory", bundle: nil)
        let loginViewController = LoginViewController.controllerInStoryboard(loginStoryboard)
        loginViewController.setFlowCompletion { [weak self] in
            self?.startMain()
        }
       self.window?.rootViewController = loginViewController

    }

    private func startMain() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

        let lotteryListViewController = LotteryListViewController.controllerInStoryboard(mainStoryboard)
        lotteryListViewController.chooseLotteryCompletion = { [weak self] in
            self?.startBuyTicket(lottery: $0)
        }
        
        navigationController.viewControllers = [lotteryListViewController]
        self.window?.rootViewController = navigationController
    }
    
    private func startBuyTicket(lottery: LotteryID) {
        let buyTicketStoryboard = UIStoryboard(name: "BuyTicketStory", bundle: nil)
        let buyTicketContainerViewController = BuyTicketContainerViewController.controllerInStoryboard(buyTicketStoryboard)
        buyTicketContainerViewController.setLottery(lottery)
        navigationController.pushViewController(buyTicketContainerViewController, animated: true)
    }
}
