//
//  ConnectTokenService.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 03.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation
import Alamofire

final class ConnectTokenService: OperationService<ConnectTokenRequestModel, ConnectTokenResponseModel> {
    override func createOperation(input: ConnectTokenRequestModel, success: @escaping ServiceSuccess, failure: @escaping ServiceFailure) -> Operation? {
        return ConnectTokenOperation(request: input, success: { (json) in
            guard let object = ConnectTokenResponseModel(json: json) else {
                failure(ServiceError.deserializationFailure)
                return
            }
            success(object)
        }, failure: failure)
    }
}
/*
 Авторизация логин-пароль-пин
 { "grant_type", "password" },
 { "username", "<userName>" },
 { "password", "<password>" },//опционально (если по пину то пароль не нужен).
 { "deviceId", "<id>" },
 { "pin", "<pin>" },
 { "scope", "<scope>" }
 
 Авторизация логин-пин
 { "grant_type", "password" },
 { "username", "<userName>" },
 { "password", "<empty>" },
 { "deviceId", "<id>" },
 { "pin", "<pin>" },
 { "scope", "<scope>" }

 */

fileprivate final class ConnectTokenOperation: APIOperation {
    override func createRequest() -> DataRequest {
        return Alamofire.request(URL(with: endpoint), method: endpoint.method.asAlamofireMethod(), parameters: parameters, encoding: URLEncoding.httpBody, headers: headers)
    }
    
    init(request: ConnectTokenRequestModel, success: @escaping APIOperationSuccess, failure: @escaping ServiceFailure) {
        let parameters = ["grant_type": request.grantType,
                          "username": request.username,
                          "password": request.password,
                          "deviceId": request.deviceID ?? "",
                          "pin": request.pin ?? "",
                          "scope": request.scope]
        
        super.init(endpoint: .connect, parameters: parameters, headers: ["Authorization": "Basic cG9ydGFibGUuY2xpZW50OnNlY3JldA=="], success: success, failure: failure)
    }
}
