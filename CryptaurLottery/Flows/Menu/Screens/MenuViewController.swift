//
//  MenuViewController.swift
//  CryptaurLottery
//
//  Created by Tim S on 19.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit
import KeychainSwift

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
        //Logout Main meny
        print("Logout button")
        let keychain = KeychainSwift()
        keychain.clear()
        dismiss(animated: true) {
            UIApplication.sharedCoordinator.showUnauth()
        }
    }
    
    @IBAction func ticketsButtonAction(_ sender: Any) {
        print("Tickets button tapped")
        //Dismiss Meny View
        dismiss(animated: true) {
            let controller = MyTicketsViewController.controllerFromStoryboard(StoryboardType.main.name)
            UIApplication.sharedCoordinator.transition(type: .push(controller: controller))
        }
    }
    
    @IBAction func changePinButtonAction(_ sender: Any) {
        print("Change PIN button")
        dismiss(animated: true) {
             UIApplication.sharedCoordinator.showPin(flow: .setPin)
        }
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
