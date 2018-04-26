import Foundation
import UInt256

struct GetPlayerAviableBalanceResponceModel: JSONDeserializable {
    
    let balance: UInt256
    
    init?(json: JSONDictionary) {
        
        guard let balanceString = json["balance"] as? String,
            let balance = UInt256(hexString: balanceString)
            else { return nil }
        
        self.balance = balance
    }
}
