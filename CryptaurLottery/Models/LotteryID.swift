//
//  LotteryID.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 04.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

enum LotteryID: Int {
    case lottery4x20 = 1
    case lottery5x36
    case lottery6x42
    
    static let count = 3
}

extension LotteryID: Diffable {
    var diffIdentifier: String {
        return "\(self)"
    }
}
