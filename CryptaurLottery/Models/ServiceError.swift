//
//  ServiceError.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

enum ServiceError: Error {
    case invalidOperation
    case unknown(Error)
    case invalidResponseFormat
    case deserializationFailure
    
    case api(code: String, message: String?)
    
    init?(json: [String: String]?) {
        guard let json = json,
        let code = json["code"] else {
            return nil
        }
        self = .api(code: code, message: json["message"])
    }
}
