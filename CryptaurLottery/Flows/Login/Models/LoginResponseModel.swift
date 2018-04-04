//
//  LoginResponseModel.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 03.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation
import UInt256

struct LoginResponseModel: JSONDeserializable {
    let session: String
    let playerAddress: UInt256
    
    init?(json: JSONDictionary) {
        guard let session = json["session"] as? String,
            let playerAddressString = json["playerAddress"] as? String,
            let playerAddress = UInt256(hexString: playerAddressString) else {
                return nil
        }
        self.session = session
        self.playerAddress = playerAddress
    }
}
