//
//  APIEndpoint.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

struct APIEndpoint {
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    let method: Method
    let path: String
    
    fileprivate init(_ method: Method, _ path: String) {
        self.method = method
        self.path = path
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
    static var login: APIEndpoint {
        return APIEndpoint(.post, "api/login")
    }
    static var refresh: APIEndpoint {
        return APIEndpoint(.get, "api/refresh")
    }
}
