//
//  BaseViewController.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol BarButtonItemTargetActions {
    func didTapMenuBarButtonItem()
}

class BaseViewController: UIViewController, BarButtonItemTargetActions, ServiceErrorAlertPresenter {
    final let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    func bind() {
    }
    
    final func bind(_ viewModel: BaseViewModel) {
        viewModel.error.drive(onNext: { [weak self] error in
            guard let error = error as? ServiceError else {
                return
            }
            self?.present(error: error)
        }).disposed(by: disposeBag)
    }
    
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
    
    func didTapMenuBarButtonItem() {
        print("Have to be overrided")
    }
}
