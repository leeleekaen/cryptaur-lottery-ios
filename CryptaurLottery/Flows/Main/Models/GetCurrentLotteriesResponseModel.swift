//
//  GetCurrentLotteriesResponseModel.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 19.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation
import UInt256

struct GetCurrentLotteriesResponseModel: JSONDeserializable {
    struct Draw: JSONDeserializable {
        let lotteryID: Int
        let number: UInt32
        let date: Date
        
        enum State: String {
            case normal, freeze, disposed
        }
        let state: State
        
        enum DrawState: String {
            case normal, partialPlayed, played, сlosed
        }
        let drawState: DrawState
        
        let jackpot: UInt256
        let reserve: UInt256
        let jackpotAdded: UInt256
        let reserveAdded: UInt256
        let ticketsBought: UInt32
        let ticketPrice: UInt256
        let numbers: [Int]?
        let buyTicketGasFee: UInt256
        
        init?(json: JSONDictionary) {
            let dateFormatter = ISO8601DateFormatter()
            
            guard let lotteryID = json["lotteryId"] as? Int,
                let number = json["number"] as? UInt32,
                let dateString = json["date"] as? String,
                let date = dateFormatter.date(from: dateString),
                let stateString = json["state"] as? String,
                let state = State(rawValue: stateString),
                let drawStateString = json["drawState"] as? String,
                let drawState = DrawState(rawValue: drawStateString),
                let jackpotString = json["jackpot"] as? String,
                let jackpot = UInt256(hexString: jackpotString),
                let reserveString = json["reserve"] as? String,
                let reserve = UInt256(hexString: reserveString),
                let jackpotAddedString = json["jackpotAdded"] as? String,
                let jackpotAdded = UInt256(hexString: jackpotAddedString),
                let reserveAddedString = json["reserveAdded"] as? String,
                let reserveAdded = UInt256(hexString: reserveAddedString),
                let ticketsBought = json["ticketsBought"] as? UInt32,
                let ticketPriceString = json["ticketPrice"] as? String,
                let ticketPrice = UInt256(hexString: ticketPriceString),
                let buyTicketGasFeeString = json["buyTicketGasFee"] as? String,
                let buyTicketGasFee = UInt256(hexString: buyTicketGasFeeString)
                else {
                    return nil
            }
            
            self.lotteryID = lotteryID
            self.number = number
            self.date = date
            self.state = state
            self.drawState = drawState
            self.jackpot = jackpot
            self.reserve = reserve
            self.jackpotAdded = jackpotAdded
            self.reserveAdded = reserveAdded
            self.ticketsBought = ticketsBought
            self.ticketPrice = ticketPrice
            self.buyTicketGasFee = buyTicketGasFee
            self.numbers = json["numbers"] as? [Int]
        }
    }
    
    let draws: [Draw]
    
    init?(json: JSONDictionary) {
        guard let list = json["draws"] as? [JSONDictionary] else {
            return nil
        }
        var draws = [Draw]()
        for item in list {
            guard let draw = Draw(json: item) else {
                return nil
            }
            draws.append(draw)
        }
        self.draws = draws
    }
}
