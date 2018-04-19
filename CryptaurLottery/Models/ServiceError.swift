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
    
    init?(json: JSONDictionary) {
        guard let errorCode = json["error"] as? String ?? json["errorCode"] as? String else {
            return nil
        }
        let errorMessasge = json["error_description"] as? String ?? json["errorMessage"] as? String
        self = .api(code: errorCode, message: errorMessasge)
    }
}
