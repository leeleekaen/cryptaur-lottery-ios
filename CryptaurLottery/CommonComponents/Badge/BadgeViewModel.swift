//
//  BadgeViewModel.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 06.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import RxSwift
import RxCocoa

protocol BadgeViewModelProtocol {
    var badge: Driver<String> { get }
    func badgeAction()
}
