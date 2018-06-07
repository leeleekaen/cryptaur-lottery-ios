//
//  APIOperation.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation
import Alamofire

typealias APIOperationSuccess = (JSONDictionary) -> ()

class APIOperation: Operation {
    let endpoint: APIEndpoint
    let headers: HTTPHeaders?
    let parameters: Parameters?
    let failure: ServiceFailure
    let success: APIOperationSuccess
    
    init(endpoint: APIEndpoint, parameters: Parameters?, headers: HTTPHeaders?, success: @escaping APIOperationSuccess, failure: @escaping ServiceFailure) {
        self.endpoint = endpoint
        self.parameters = parameters
        self.headers = headers
        self.success = success
        self.failure = failure
        super.init()
    }
    
    func URL(with endpoint: APIEndpoint) -> URLConvertible {
        return endpoint
    }
    
    func createRequest() -> Alamofire.DataRequest {
        return Alamofire.request(URL(with: endpoint), method: endpoint.method.asAlamofireMethod(), parameters: parameters, encoding: URLEncoding.default, headers: headers)
    }
    
    final override func main() {
        
        let success = self.success
        let failure = self.failure
        let request = createRequest()
        
        request.responseJSON(queue: DispatchQueue.global(qos: .utility), options: .allowFragments) { (response: DataResponse<Any>) in
            
            guard !APIOperation.processErrors(handler: failure, response: response) else {
                return
            }
            
            // force cast because conditional cast already checked in `processErrors()`
            let responseValue = response.value as! JSONDictionary
            success(responseValue)
        }
    }
    
    private class func processErrors(handler: ServiceFailure, response: DataResponse<Any>) -> Bool {
        
        if let error = response.error {
            handler(ServiceError.unknown(error))
            return true
        }
        guard let json = response.value as? JSONDictionary else {
            
            handler(ServiceError.invalidResponseFormat)
            return true
        }
        if let error = ServiceError(json: json) {
            handler(error)
            return true
        }
        return false
    }
}

extension APIEndpoint.Method {
    func asAlamofireMethod() -> Alamofire.HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        }
    }
}
