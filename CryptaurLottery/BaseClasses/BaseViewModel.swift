//
//  BaseViewModel.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//


import RxSwift
import RxCocoa

class BaseViewModel {
    final let disposeBag = DisposeBag()
    
    final let errorSubject = BehaviorSubject<Error?>(value: nil)
    final var error: Driver<Error?> {
        return errorSubject.asDriver(onErrorJustReturn: nil)
    }
    
    final lazy private(set) var defaultServiceFailure: ServiceFailure = {
        return { [weak self] in
            self?.errorSubject.onNext($0)
        }
    }()
}
