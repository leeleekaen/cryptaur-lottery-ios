//
//  BaseViewController.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit
import RxSwift

@objc protocol BaseViewControllerProtocol {
    @objc func didTapMenuBarButtonItem(_ sender: UIBarButtonItem)
    @objc func didTapTicketNumberBarButtonItem(_ sender: UIBarButtonItem)
}

class BaseViewController: UIViewController {
    final let disposeBag = DisposeBag()
}

extension BaseViewController {
    private struct StaticPropertyHolder {
        private init() {}
        static let menuBarButtonItemImage = #imageLiteral(resourceName: "purse")
        static let ticketNumberBarButtonItemImage = #imageLiteral(resourceName: "purse")
    }
    
    func createBalanceView() -> BalanceView? {
        guard let balanceView = UINib(nibName: "BalanceView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? BalanceView else {
            return nil
        }
        balanceView.bind(viewModel: MockBalanceViewModel(), disposeBag: disposeBag)
        return balanceView
    }
    
    func createMenuBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(image: StaticPropertyHolder.menuBarButtonItemImage, style: .plain, target: self, action: #selector(didTapMenuBarButtonItem(_:)))
    }
    
    func createTicketNumberBarButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(StaticPropertyHolder.ticketNumberBarButtonItemImage, for: .normal)
        button.addTarget(self, action: #selector(didTapTicketNumberBarButtonItem(_:)), for: .touchUpInside)
        button.setNeedsLayout()
        button.setNeedsDisplay()
        return UIBarButtonItem(customView: button)
    }
}

extension BaseViewController: BaseViewControllerProtocol {
    func didTapMenuBarButtonItem(_ sender: UIBarButtonItem) {
        
    }
    
    func didTapTicketNumberBarButtonItem(_ sender: UIBarButtonItem) {
        
    }
}
