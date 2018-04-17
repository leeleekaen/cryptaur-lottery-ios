//
//  MyTicketsViewController.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 14.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit
import IGListKit

class MyTicketsViewController: BaseViewController {
    @IBOutlet weak var gradientBackgroundView: GradientBackgroundView!
    
    @IBOutlet weak var prizePoolAmountLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //    lazy private var adapter: ListAdapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)

    @IBOutlet weak var getTheWinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradientBackgroundView.gradientColors = [UIColor.lightblue, UIColor.lighterPurple].map {$0.cgColor}
        gradientBackgroundView.backgroundColor = .clear
        
        configureNavigationItem(showBalance: true)
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    }
    
    @IBAction func didTapGetTheWinButton(_ sender: UIButton) {
    }
}
