//
//  LoginResponseModel.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 03.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation
import UInt256

struct LoginResponseModel {
    let session: String
    let playerAddress: UInt256
    
    init?(json: JSONDictionary) {
        guard let session = json["session"],
            let playerAddressString = json["playerAddress"],
            let playerAddress = UInt256(playerAddressString) else {
                return nil
        }
        self.session = session
        self.playerAddress = playerAddress
    }
}
