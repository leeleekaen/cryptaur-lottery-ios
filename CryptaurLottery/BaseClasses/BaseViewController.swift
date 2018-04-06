//
//  BaseViewController.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit
import RxSwift

protocol BarButtonItemTargetActions {
    func didTapMenuBarButtonItem()
}

class BaseViewController: UIViewController, BarButtonItemTargetActions {
    final let disposeBag = DisposeBag()

    final func configureNavigationItem(showBalance: Bool) {
        if showBalance {
            navigationItem.titleView = createBalanceView()
        }
        navigationItem.rightBarButtonItems = [createMenuBarButtonItem(), createBadgeBarButtonItem()]
    }
    
    private func createBalanceView() -> BalanceView? {
        let balanceView = BalanceView.loadFromNib()
        balanceView.bind(viewModel: MockBalanceViewModel(), disposeBag: disposeBag)
        return balanceView
    }
    
    private func createMenuBarButtonItem() -> UIBarButtonItem {
        return .menu(target: self, action: #selector(didTapMenuBarButtonItem(_:)))
    }
    
    @objc private func didTapMenuBarButtonItem(_ sender: UIBarButtonItem) {
        didTapMenuBarButtonItem()
    }
    
    private func createBadgeBarButtonItem() -> UIBarButtonItem {
        return .badge(viewModel: MockBalanceViewModel(), disposeBag: disposeBag)
    }
}

extension BarButtonItemTargetActions where Self: BaseViewController {
    func didTapMenuBarButtonItem() {
        
    }
}
