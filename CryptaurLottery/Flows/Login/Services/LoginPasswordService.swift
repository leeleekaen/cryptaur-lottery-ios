//
//  LoginService.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 03.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation

final class LoginPasswordService: BaseService<LoginPasswordRequestModel, LoginResponseModel> {
    override func createOperation(input: LoginPasswordRequestModel, success: @escaping ServiceSuccess, failure: @escaping ServiceFailure) -> Operation? {
        return LoginOperation(request: input, success: success, failure: failure)
    }
}
