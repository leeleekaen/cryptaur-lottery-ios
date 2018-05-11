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
    
    var toPick: Int {
        
        switch self {
        case .lottery4x20:
            return 4
        case .lottery5x36:
            return 5
        case .lottery6x42:
            return 6
        }
    }
    
    var total: Int {
        
        switch self {
        case .lottery4x20:
            return 20
        case .lottery5x36:
            return 36
        case .lottery6x42:
            return 42
        }
    }
    
    static var allValues: [LotteryID] {
        return  [.lottery4x20, .lottery5x36, .lottery6x42]
    }
}

extension LotteryID: Diffable {
    var diffIdentifier: String {
        return "\(self)"
    }
}
