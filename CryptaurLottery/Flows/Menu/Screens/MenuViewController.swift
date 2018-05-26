//
//  MenuViewController.swift
//  CryptaurLottery
//
//  Created by Tim S on 19.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var purseButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var loginNameLabel: UILabel!
    
    // MARK: - IBAction
    @IBAction func closeButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func purseButtonAction(_ sender: Any) {
        print("Purse button tapped");
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        logoutCompletion?()
    }
    
    @IBAction func ticketsButtonAction(_ sender: Any) {
        print("Tickets button tapped")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let myTicketsViewController = MyTicketsViewController.controllerInStoryboard(mainStoryboard)
        //self.addVcNavigationController(vc: myTicketsViewController)
        //myTicketsViewController.menuActionCompletion = self?.menuActionCompletion
//        dismiss(animated: true, completion: nil)
        self.transition(type: TransistionType.present(controller: BaseNavigationController.createNavBar(viewController: myTicketsViewController)))
        //myTicketsCompletion?()
    }
    
    @IBAction func changePinButtonAction(_ sender: Any) {
        changePINCompletion?()
    }
    
    @IBAction func howToPlayButtonAction(_ sender: Any) {
        print("HowToPlay button tapped");
    }
    
    // MARK: - Public properties
    var logoutCompletion: (() -> ())?
    var changePINCompletion: (() -> ())?
    var myTicketsCompletion: (() -> ())?
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
