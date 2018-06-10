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
    
fileprivate extension UINavigationBar {
    func makeTransparent() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
    }
}

