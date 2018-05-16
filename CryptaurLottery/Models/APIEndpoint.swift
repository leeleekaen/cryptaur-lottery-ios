//
//  APIEndpoint.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation
import Alamofire

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

extension APIEndpoint: URLConvertible {
    private struct BaseURLStorage {
//        #if DEBUG
//        static let baseUrl = URL(string: "http://192.168.4.199:24892")
//        #else
//        static let baseUrl = URL(string: "https://lottery-3.cryptaur.com")
//        #endif
        static let baseUrl = URL(string: "http://192.168.4.199:24892")
    }

    func asURL() throws -> URL {
        let baseURL = self.baseURL ?? BaseURLStorage.baseUrl
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw AFError.invalidURL(url: self)
        }
        return url
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
    static var getWinTickets: APIEndpoint {
        return APIEndpoint(.get, "api/getWinTickets")
    }
    static var refresh: APIEndpoint {
        return APIEndpoint(.get, "api/refresh")
    }
    static var connect: APIEndpoint {
        return APIEndpoint(.post, "connect/token", "https://lottery-1.cryptaur.com")
    }
    static var getCurrentLotteries: APIEndpoint {
        return APIEndpoint(.get, "api/getCurrentLotteries")
    }
    static var getWinAmount: APIEndpoint {
        return APIEndpoint(.get, "api/getWinAmount")
    }
    static var pickUpWin: APIEndpoint {
        return APIEndpoint(.post, "api/pickUpWin")
    }
    static var buyTickets: APIEndpoint {
        return APIEndpoint(.post, "api/buyTickets")
    }
    static var getPlayerAviableBalance: APIEndpoint {
        return APIEndpoint(.get, "api/getPlayerAviableBalance")
    }
}
