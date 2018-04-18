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
    
    case api(code: String?, message: String?)
    
    init?(json: JSONDictionary) {
        let error = json["error"] as? String
        let errorDescription = json["error_description"] as? String
        if let code = error, let message = errorDescription  {
            self = .api(code: code, message: message)
            return
        }

//        if let code = json["code"] as? String {
//            self = .api(code: code, message: json["message"] as? String)
//            return
//        }
        
        return nil
    }
}
