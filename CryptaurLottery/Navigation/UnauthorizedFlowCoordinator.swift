//
//  UnauthorizedFlowCoordinator.swift
//  CryptaurLottery
//
//  Created by Artem Pashkevich on 26.05.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation

class UnathorizedFlowCoordinator: ChildCoordinator {
    var rootCoordinator: ApplicationCoordinator
    
    // MARK: Private properties
    
    init(rootCoordinator: ApplicationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func start() {
        let controller = BaseNavigationController.createNavBar(viewController: LoginViewController.controllerFromStoryboard(StoryboardType.login.name))
        rootCoordinator.transition(type: .setRootWindow(controller: controller))
    }
}
