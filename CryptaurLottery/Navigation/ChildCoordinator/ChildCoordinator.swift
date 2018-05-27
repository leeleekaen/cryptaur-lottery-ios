//
//  ChildCoordinator.swift
//  CryptaurLottery
//
//  Created by Artem Pashkevich on 26.05.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation

protocol ChildCoordinator {
    var rootCoordinator: ApplicationCoordinator { get set }
    
    func start()
}
