//
//  BaseNavigationController.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 05.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseNavigationController: UINavigationController  {
    
    
    
    static func createNavBar(viewController: UIViewController) -> BaseNavigationController {
        return BaseNavigationController(rootViewController: viewController)
    }
    
    let disposeBag = DisposeBag()
    let balanceViewModel = BalanceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.tintColor = .white
        navigationBar.makeTransparent()
    }
}
//extension BaseNavigationController: BarButtonItemTargetActions {
//
//    func configureNavigationItem(showBalance: Bool, color: UIColor = .white) {
//        if showBalance {
//            navigationItem.titleView = createBalanceView(color: color)
//        }
//            navigationItem.rightBarButtonItems = [createMenuBarButtonItem(), createBadgeBarButtonItem()]
//    }
//
//
//    private func createMenuBarButtonItem() -> UIBarButtonItem {
//        return .menu(target: self, action: #selector(didTapMenuBarButtonItem(_:)))
//    }
//
//    @objc private func didTapMenuBarButtonItem(_ sender: UIBarButtonItem) {
//        didTapMenuBarButtonItem()
//    }
//
//
//    private func createBalanceView(color: UIColor) -> BalanceView? {
//        let balanceView = BalanceView.loadFromNib()
//        balanceView.setColor(color)
//        balanceView.bind(viewModel: balanceViewModel, disposeBag: disposeBag)
//        return balanceView
//    }
//    private func createBadgeBarButtonItem() -> UIBarButtonItem {
//        balanceViewModel.badgeActionCompletion = { [weak self] in
//            let controller = MyTicketsViewController.controllerFromStoryboard(StoryboardType.main.name)
//            UIApplication.sharedCoordinator.transition(type: .push(controller: controller))
//        }
//        return .badge(viewModel: balanceViewModel, disposeBag: disposeBag)
//    }
//
//    func didTapMenuBarButtonItem() {
//        let controller = MenuViewController.controllerFromStoryboard(StoryboardType.menuStory.name)
//        UIApplication.sharedCoordinator.transition(type: .present(controller: controller, completion: nil))
//        controller.bind(viewModel: balanceViewModel, disposeBag: disposeBag)
//    }
//
//    func didTapBadgeButton() {
//        let controller = MyTicketsViewController.controllerFromStoryboard(StoryboardType.main.name)
//        UIApplication.sharedCoordinator.transition(type: .push(controller: controller))
//    }
//}

    
fileprivate extension UINavigationBar {
    func makeTransparent() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
    }
}

