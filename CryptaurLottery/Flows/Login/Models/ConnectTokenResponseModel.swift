//
//  LoginResponseModel.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 03.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation
import UInt256

struct ConnectTokenResponseModel: JSONDeserializable {
    let accessToken: String
    let expiresIn: Int
    let tokenType: String
    let refreshToken: String
    let address: UInt256
/*{
 "access_token": "eyJhbGciOiJSUzI1NiIsImt...",
 "expires_in": 900,
 "token_type": "Bearer",
 "refresh_token": "090f0a16e226710f403ffba5de3bfb3fc07c194d40e6f0681757b9fb78b66bac",
 "address": "0x456"
 }
 */
    
    init?(json: JSONDictionary) {
        guard let accessToken = json["access_token"] as? String,
            let addressString = json["address"] as? String,
            let address = UInt256(hexString: addressString),
        let expiresIn = json["expires_in"] as? Int,
        let tokenType = json["token_type"] as? String,
        let refreshToken = json["refresh_token"] as? String else {
                return nil
        }
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.tokenType = tokenType
        self.refreshToken = refreshToken
        self.address = address
    }
}
