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
        print("Logout button tapped");
    }
    
    @IBAction func ticketsButtonAction(_ sender: Any) {
        print("Tickets button tapped");
    }
    
    @IBAction func changePinButtonAction(_ sender: Any) {
        print("ChangePin button tapped");
    }
    
    @IBAction func howToPlayButtonAction(_ sender: Any) {
        print("HowToPlay button tapped");
    }
    
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
