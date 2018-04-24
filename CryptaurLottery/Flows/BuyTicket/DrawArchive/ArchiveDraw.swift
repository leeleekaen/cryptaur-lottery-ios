import Foundation
import UInt256

struct ArchiveDraw: JSONDeserializable, Diffable {
    
    var diffIdentifier: String {
        return "\(number)"
    }
    
    let number: Int
    let date: Date
    let numbers: [Int]?
    let jackpot: UInt256
    
    init?(json: JSONDictionary) {
        
        let dateFormatter = ISO8601DateFormatter()
        
        guard let number = json["number"] as? Int,
            let dateString = json["date"] as? String,
            let date = dateFormatter.date(from: dateString),
            let jackpotString = json["jackpot"] as? String,
            let jackpot = UInt256(hexString: jackpotString) else {
                return nil
        }
        
        self.number = number
        self.date = date
        self.jackpot = jackpot
        self.numbers = json["numbers"] as? [Int]
    }
}
