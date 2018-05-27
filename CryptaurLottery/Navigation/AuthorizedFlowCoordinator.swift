//
//  AuthorizedFlowCoordinator.swift
//  CryptaurLottery
//
//  Created by Artem Pashkevich on 26.05.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit

class AuthorizedFlowCoordinator: ChildCoordinator {
    
    var rootCoordinator: ApplicationCoordinator
    
    init(rootCoordinator: ApplicationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func start() {
        let controller = LotteryListViewController.controllerFromStoryboard(StoryboardType.main.name)
        self.rootCoordinator.transition(type: .setRootWindow(controller: controller))
    }
}
