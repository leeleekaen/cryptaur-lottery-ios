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
        let navigationController = BaseNavigationController()

        let lotteryListViewController = LotteryListViewController.controllerInStoryboard(mainStoryboard)
        navigationController.viewControllers = [lotteryListViewController]
        self.window?.rootViewController = navigationController
    }
}
