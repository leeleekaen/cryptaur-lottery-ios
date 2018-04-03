//
//  LoginPasswordRequestModel.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 03.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation

struct LoginPasswordRequestModel {
    let login: String
    let password: String
    let pin: String?
    let key: String
}
