import Foundation
import UInt256

//{
//    "drawIndex":1,                      // номер тиража, int32
//    "date":"2018-12-03T10:15:30Z",      // ISO-8601, instant YYYY-MM-DDThh:mm:ssZ, timezone = 0; дата и время проведения розыгрыша
//    "ticketIndex":27,                   // номер билета, int32
//    "winLevel": 2,                      // количество выигрышных номеров билета, -1 если тираж еще не состоялся (наверное возможно сделать null [зачем null? -1 -- вполне подходит]), int32
//    "winAmount":"0x203040",             // величина выигрыша билета, -1 если тираж еще не состоялся (наверное возможно сделать null), int256 // может быть вообще не указывать поле если выигрыш не состоялся?
//    "price":"0x203040",                 // цена билета,
//    "numbers":[1,2,-3,-19,22,36]                // числа в билете, int32[TicketNumbersCount], выигрышные номера записаны со знаком -
//
//}

struct Ticket {
    
    var drawIndex: Int
    var date: Date
    var ticketIndex: Int
    var winLevel: Int
    var winAmount: UInt256
    var price: UInt256
    var numbers: [Int]
    
    private let dateFormatter = ISO8601DateFormatter()
    
    init?(json: JSONDictionary) {
        
        guard let drawIndex = json["drawIndex"] as? Int,
                let dateString = json["date"] as? String,
                let date = dateFormatter.date(from: dateString),
                let ticketIndex = json["ticketIndex"] as? Int,
                let winLevel = json["winLevel"] as? Int,
                let winAmountString = json["winAmount"] as? String,
                let winAmount = UInt256(hexString: winAmountString),
                let priceString = json["price"] as? String,
                let price = UInt256(hexString: priceString),
                let numbers = json["numbers"] as? [Int]
            else {
                return nil
        }
        
        self.drawIndex = drawIndex
        self.date = date
        self.ticketIndex = ticketIndex
        self.winLevel = winLevel
        self.winAmount = winAmount
        self.price = price
        self.numbers = numbers
    }
}
