//
//  LoginService.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 03.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation

final class LoginPasswordService: OperationService<LoginPasswordRequestModel, LoginResponseModel> {
    private final class LoginOperation: APIOperation {
        init(request: LoginPasswordRequestModel, success: @escaping APIOperationSuccess, failure: @escaping ServiceFailure) {
            var parameters = ["login": request.login,
                              "password": request.password,
                              "key": request.key]
            if let pin = request.pin {
                parameters["pin"] = pin
            }
            
            super.init(endpoint: .login, parameters: parameters, headers: nil, success: success, failure: failure)
        }
    }

    override func createOperation(input: LoginPasswordRequestModel, success: @escaping ServiceSuccess, failure: @escaping ServiceFailure) -> Operation? {
        return LoginOperation(request: input, success: { (json) in
            guard let object = LoginResponseModel(json: json) else {
                failure(ServiceError.deserializationFailure)
                return
            }
            success(object)
        }, failure: failure)
    }
}
