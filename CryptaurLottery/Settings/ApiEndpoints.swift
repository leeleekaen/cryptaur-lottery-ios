//
//  ApiEndpoints.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

final class ApiEndpoints {
    static let getTicketPrice = HttpEndpoint(.GET, "api/getTicketPrice")
    static let getState = HttpEndpoint(.GET, "api/getState")
    static let getDraws = HttpEndpoint(.GET, "api/getDraws")
    static let getCurrentDraws = HttpEndpoint(.GET, "api/getCurrentDraws")
    static let getPlayerTickets = HttpEndpoint(.GET, "api/getPlayerTickets")
    static let login = HttpEndpoint(.POST, "api/login")
    static let refresh = HttpEndpoint(.GET, "api/refresh")
}
