//
//  APIEndpoint.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation

struct APIEndpoint {
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    let method: Method
    let path: String
    let baseURLString: String?
    
    var baseURL: URL? {
        guard let baseURLString = baseURLString else {
            return nil
        }
        return URL(string: baseURLString)
    }
    
    fileprivate init(_ method: Method, _ path: String, _ baseURLString: String? = nil) {
        self.method = method
        self.path = path
        self.baseURLString = baseURLString
    }
}

extension APIEndpoint {
    static var getTicketPrice: APIEndpoint {
        return APIEndpoint(.get, "api/getTicketPrice")
    }
    static var getState: APIEndpoint {
        return APIEndpoint(.get, "api/getState")
    }
    static var getDraws: APIEndpoint {
        return APIEndpoint(.get, "api/getDraws")
    }
    static var getCurrentDraws: APIEndpoint {
        return APIEndpoint(.get, "api/getCurrentDraws")
    }
    static var getPlayerTickets: APIEndpoint {
        return APIEndpoint(.get, "api/getPlayerTickets")
    }
    static var refresh: APIEndpoint {
        return APIEndpoint(.get, "api/refresh")
    }
    static var connect: APIEndpoint {
        return APIEndpoint(.post, "connect/token", "http://54.245.214.56:24872")
    }
    
}
