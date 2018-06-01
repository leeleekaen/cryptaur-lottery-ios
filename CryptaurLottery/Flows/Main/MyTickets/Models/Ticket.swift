import Foundation
import UInt256


struct Ticket {
    
    var drawIndex: Int
    var date: Date
    var ticketIndex: Int
    var winLevel: Int
    var winAmount: UInt256
    var price: UInt256
    var numbers: [Int]
    var lotteryId: Int
    
    private let dateFormatter = ISO8601DateFormatter()
    
    init?(json: JSONDictionary) {
                
        guard let drawIndex = json["drawIndex"] as? Int,
                let dateString = json["drawDate"] as? String,
                let date = dateFormatter.date(from: dateString),
                let ticketIndex = json["ticketIndex"] as? Int,
                let winLevel = json["winLevel"] as? Int,
            
                let priceString = json["price"] as? String,
                let price = UInt256(hexString: priceString),
                let numbers = json["numbers"] as? [Int],
                let lotteryId = json["lotteryId"] as? Int
            else {
                return nil
        }
        
        if ((json["winAmount"] as? String) != nil) {
            let winAmountString = json["winAmount"] as! String
            self.winAmount = UInt256(hexString: winAmountString)!
        }else{
            let winAmountString = "0"
            self.winAmount = UInt256(hexString: winAmountString)!
        }
        
        
        
        self.drawIndex = drawIndex
        self.date = date
        self.ticketIndex = ticketIndex
        self.winLevel = winLevel
        self.lotteryId = lotteryId
//        self.winAmount = winAmount
        self.price = price
        self.numbers = numbers
    }
}

extension Ticket: Equatable {
    static func == (lhs: Ticket, rhs: Ticket) -> Bool {
        return
            lhs.drawIndex == rhs.drawIndex &&
                lhs.date == rhs.date &&
                lhs.ticketIndex == rhs.ticketIndex &&
                lhs.winLevel == rhs.winLevel &&
                lhs.lotteryId == rhs.lotteryId &&
                lhs.price == rhs.price 
                lhs.numbers == rhs.numbers
    }
}

extension Ticket: Diffable {
    var diffIdentifier: String {
        return "\(date) \(drawIndex) \(ticketIndex)"
    }
}
