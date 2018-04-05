//
//  LotteryListViewController.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 05.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit
import iCarousel

class LotteryListViewController: BaseViewController {
    @IBOutlet weak var gradientBackgroundView: GradientBackgroundView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = createBalanceView()
        navigationItem.rightBarButtonItems = [createTicketNumberBarButtonItem(), createMenuBarButtonItem()]
        
        gradientBackgroundView.gradientColors = [UIColor.lightblue, UIColor.lighterPurple].map {$0.cgColor}
    }
}
