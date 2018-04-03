//
//  APIOperation.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation
import Alamofire

class APIOperation: Operation {
    typealias JSONDictionary = [String: String]
    let endpoint: APIEndpoint
    let headers: HTTPHeaders?
    let parameters: Parameters?
    let failure: ServiceFailure
    
    init(endpoint: APIEndpoint, parameters: Parameters?, headers: HTTPHeaders?, failure: @escaping ServiceFailure) {
        self.endpoint = endpoint
        self.parameters = parameters
        self.headers = headers
        self.failure = failure
        super.init()
    }
    
    func createRequest() -> Alamofire.DataRequest {
        return Alamofire.request(endpoint, method: endpoint.method.asAlamofireMethod(), parameters: parameters, encoding: URLEncoding.default, headers: headers)
    }
    
    final class func processErrors(handler: ServiceFailure, response: DataResponse<Any>) -> Bool {
        if let error = response.error {
            handler(ServiceError.unknown(error))
            return true
        }
        guard let json = response.value as? JSONDictionary else {
            handler(ServiceError.noData)
            return true
        }
        if let error = ServiceError(json: json) {
            handler(error)
            return true
        }
        return false
    }
}

extension APIEndpoint: URLConvertible {
    private struct BaseURLStorage {
        #if DEBUG
        static let baseUrl = URL(string: "http://lottery.nordavind.ru")
        #else
        static let baseUrl = URL(string: "https://lottery.cryptaur.com")
        #endif
    }
    
    func asURL() throws -> URL {
        guard let url = URL(string: path, relativeTo: BaseURLStorage.baseUrl) else {
            throw AFError.invalidURL(url: self)
        }
        return url
    }
}

fileprivate extension APIEndpoint.Method {
    func asAlamofireMethod() -> Alamofire.HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        }
    }
}
