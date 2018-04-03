//
//  LoginResponseModel.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 03.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation

struct LoginResponseModel {
    let session: String
    let playerAddress: String
    
    init?(json: [String: String]?) {
        guard let json = json else {
            return nil
        }
        guard let session = json["session"],
            let playerAddress = json["playerAddress"] else {
                return nil
        }
        self.session = session
        self.playerAddress = playerAddress
    }
}
