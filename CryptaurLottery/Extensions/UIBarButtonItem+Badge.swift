//
//  UIBarButtonItem+Badge.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 06.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import RxSwift

extension UIBarButtonItem {
    class func badge(viewModel: BadgeViewModelProtocol, disposeBag: DisposeBag) -> UIBarButtonItem {
        let badgeView = BadgeView.loadFromNib()
        badgeView.bind(viewModel: viewModel, disposeBag: disposeBag)
        return UIBarButtonItem(customView: badgeView)
    }
}
