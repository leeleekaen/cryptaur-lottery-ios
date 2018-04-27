import Foundation
import UInt256

struct ArchiveDraw: JSONDeserializable, Diffable {
    
    var diffIdentifier: String {
        return "\(number)"
    }
    
    let number: Int
    let date: Date
    let drawState: DrawState
    let jackpot: UInt256
    let reserve: UInt256
    let jackpotAdded: UInt256
    let reserveAdded: UInt256
    let ticketsBought: UInt32
    let ticketPrice: UInt256
    let buyTicketGasFee: UInt256?
    let numbers: [Int]
    
    init?(json: JSONDictionary) {
                
        let dateFormatter = ISO8601DateFormatter()
        
        guard let number = json["number"] as? Int,
            let dateString = json["date"] as? String,
            let date = dateFormatter.date(from: dateString),
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
            let numbers = json["numbers"] as? [Int] else { return nil }
        
        self.number = number
        self.date = date
        self.drawState = drawState
        self.jackpot = jackpot
        self.reserve = reserve
        self.jackpotAdded = jackpotAdded
        self.reserveAdded = reserveAdded
        self.ticketsBought = ticketsBought
        self.ticketPrice = ticketPrice
        if let buyTicketGasFeeString = json["buyTicketGasFee"] as? String {
            self.buyTicketGasFee = UInt256(hexString: buyTicketGasFeeString)
        } else {
            self.buyTicketGasFee = nil
        }
        self.numbers = numbers
    }
}

// MARK: - Enbedded types
extension ArchiveDraw {
    
    enum DrawState: String {
        case normal, partialPlayed, played, closed
    }
}
