//
//  HttpEndpoint.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

struct HttpEndpoint {
    typealias Endpoint = String
    
    enum Method: String {
        case GET = "GET"
        case POST = "POST"
    }
    
    let method: Method
    let endpoint: Endpoint
    
    init(_ method: Method, _ endpoint: Endpoint) {
        self.method = method
        self.endpoint = endpoint
    }
}
