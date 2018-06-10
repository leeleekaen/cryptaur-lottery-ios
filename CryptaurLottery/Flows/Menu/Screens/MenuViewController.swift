//
//  MenuViewController.swift
//  CryptaurLottery
//
//  Created by Tim S on 19.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import UInt256
import KeychainSwift

class MenuViewController: BaseViewController {

    private var viewModelBalance: BalanceViewModel!
    private var viewModelBadge: BadgeViewModelProtocol!
    
     // MARK: - IBOutlets
    @IBOutlet weak var winTicketsButton: UIButton!
    @IBOutlet weak var purseButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var playerAddressLabel: UILabel!
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK: bind
    func bind(viewModel: BalanceViewModel, disposeBag: DisposeBag) {
        self.viewModelBalance = viewModel
        viewModelBalance.balance.drive(onNext: { [weak self] in
            self?.purseButton.setTitle($0, for: .normal)
        }).disposed(by: disposeBag)
        
        viewModelBalance.badge.drive(onNext: { [weak self] value in
            DispatchQueue.main.async {
                self?.winTicketsButton.setTitle(value, for: .normal)
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: - IBAction
extension MenuViewController {
    @IBAction func closeButtonAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func purseButtonAction(_ sender: Any) {
        print("Purse button tapped")
        viewModelBalance.balanceAction()
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
            UIApplication.sharedCoordinator.showPin(flow: .setPin, exitType: .changePin)
        }
    }
    
    @IBAction func howToPlayButtonAction(_ sender: Any) {
        print("HowToPlay button tapped");
    }
}

//MARK: Setup View
extension MenuViewController {
    func setupView() {
        let keychain = KeychainSwift()
        guard let hexAddress = keychain.get(PlayersKey.address),
            let playerAddress = UInt256(hexString: hexAddress)  else { return }
        print("playerAddress - \(playerAddress.toString())")
        playerAddressLabel.text = playerAddress.toString()
    }
}
