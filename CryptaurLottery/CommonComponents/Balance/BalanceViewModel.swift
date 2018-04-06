//
//  BalanceViewModel.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 05.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import RxSwift
import RxCocoa

protocol BalanceViewModelProtocol {
    var balance: Driver<String> { get }
    func purseAction()
    func balanceAction()
}

final class MockBalanceViewModel: BalanceViewModelProtocol, BadgeViewModelProtocol {
    var balance:  Driver<String> {
        return balanceSubject.asDriver(onErrorJustReturn: "")
    }
    
    private let balanceSubject = BehaviorSubject<String>(value: "0.00000000 CPT")
    private let badgeSubject = BehaviorSubject<String>(value: "1")
    private var showAvailableBalance = false
    
    func purseAction() {
    }
    
    func balanceAction() {
        if showAvailableBalance {
            balanceSubject.onNext("100.000 CPT (available)")
        } else {
            balanceSubject.onNext("100,000.000 CPT")
        }
        showAvailableBalance.toggle()
    }

    var badge: Driver<String> {
        return badgeSubject.asDriver(onErrorJustReturn: "")
    }
    
    func badgeAction() {
        badgeSubject.onNext("12")
    }
}

extension Bool {
    @discardableResult
    mutating func toggle() -> Bool {
        self = !self
        return self
    }
}
