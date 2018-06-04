import Foundation

struct BuyTicketResponceModel: JSONDeserializable {
    
    let trxHash: String
    
    init?(json: JSONDictionary) {
    
        guard let trxHash = json["trxHash"] as? String else { return nil }
        
        self.trxHash = trxHash
    }
}
