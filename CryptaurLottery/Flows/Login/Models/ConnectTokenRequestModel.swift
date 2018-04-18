//
//  ConnectTokenRequestModel.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 03.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation
import UIKit

struct ConnectTokenRequestModel {
    let grantType = "password"
    let username: String
    let password: String
    let deviceID = UIDevice.current.identifierForVendor?.uuidString
    let pin: String?
    let scope = "lottery_main offline_access"
}
