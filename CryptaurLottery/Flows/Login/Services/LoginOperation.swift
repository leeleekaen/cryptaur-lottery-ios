//
//  LoginOperation.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 03.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Alamofire

final class LoginOperation: APIOperation {
    private let success: (LoginResponseModel) -> ()
    
    init(request: LoginPasswordRequestModel, success: @escaping (LoginResponseModel) -> (), failure: @escaping ServiceFailure) {
        var parameters = ["login": request.login,
                          "password": request.password,
                          "key": request.key]
        if let pin = request.pin {
            parameters["pin"] = pin
        }
        self.success = success
        super.init(endpoint: .login, parameters: parameters, headers: nil, failure: failure)
    }
    
    override func main() {
        let request = createRequest()
        let success = self.success
        let failure = self.failure
        
        request.response(queue: DispatchQueue.global(qos: .utility), responseSerializer: DataRequest.jsonResponseSerializer(), completionHandler: { (response) in
            guard !APIOperation.processErrors(handler: failure, response: response) else {
                return
            }
            if let json = response.value as? JSONDictionary,
                let responseModel = LoginResponseModel(json: json) {
                success(responseModel)
            }
            else {
                failure(ServiceError.deserializationFailure)
            }
        })
    }
}
