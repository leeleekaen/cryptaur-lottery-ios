//
//  LotteryListViewModel.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 19.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation

final class LotteryListViewModel: BaseViewModel {
    var draws: [Draw]?
    
    private var service = GetCurrentLotteriesService()
    
    override init() {
        super.init()
        
        service.perform(input: (), success: { [weak self] (response) in
            self?.draws = response.draws
        }, failure: defaultServiceFailure)
    }
}
