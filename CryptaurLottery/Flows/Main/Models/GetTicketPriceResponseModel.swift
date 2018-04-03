//
//  GetTicketPriceResponseModel.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 03.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation
import UInt256

struct GetTicketPriceResponseModel {
    let price: UInt256
    
    init?(json: JSONDictionary) {
        guard let priceString = json["price"],
        let price = UInt256(priceString) else {
            return nil
        }
        self.price = price
    }
}
