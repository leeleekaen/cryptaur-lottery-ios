//
//  SetPinFlowCoordinator.swift
//  CryptaurLottery
//
//  Created by Artem Pashkevich on 26.05.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation

class SetPinFlowCoordinator: ChildCoordinator {
    var rootCoordinator: ApplicationCoordinator
    var pinControllerFlow: PinCodeViewController.Flow = .askPin
    
    // MARK: Private properties
    
    init(rootCoordinator: ApplicationCoordinator) {
        self.rootCoordinator = rootCoordinator
    }
    
    func start() {
        let controller = PinCodeViewController.controllerFromStoryboard(StoryboardType.login.name)
        controller.flow = pinControllerFlow
        rootCoordinator.transition(type: .setRootWindow(controller: controller))
    }
}
