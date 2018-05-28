//
//  CoordinatorType.swift
//  CryptaurLottery
//
//  Created by Artem Pashkevich on 27.05.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation
import UIKit

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
