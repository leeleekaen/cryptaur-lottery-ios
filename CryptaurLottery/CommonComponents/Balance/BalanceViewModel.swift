//
//  BalanceViewModel.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 05.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import RxSwift
import RxCocoa

class BalanceViewModel: BaseViewModel {
    final let balanceSubject = BehaviorSubject<String>(value: "0.00000000 CPT")
    final var balance: Driver<String> {
        return balanceSubject.asDriver(onErrorJustReturn: "")
    }
    
    func purseAction() {
    }
    
    func balanceAction() {
    }
}

final class MockBalanceViewModel: BalanceViewModel {
    override init() {
        super.init()
        balanceSubject.onNext("667.000 CPT")
    }
    
    override func purseAction() {
        balanceSubject.onNext("100,000,000.000 CPT")
    }
    
    override func balanceAction() {
        balanceSubject.onNext("100.000 CPT")
    }
}
