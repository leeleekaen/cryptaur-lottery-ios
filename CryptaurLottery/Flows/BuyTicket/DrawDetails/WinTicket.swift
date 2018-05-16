import Foundation
import UInt256

struct WinTicket: JSONDeserializable {
    
    let playerAddress: UInt256
    let index: Int32
    let winLevel: Int32
    let winAmount: UInt256
    
    init?(json: JSONDictionary) {
        
        guard let playerAddressString = json["playerAddress"] as? String,
            let playerAddress = UInt256(hexString: playerAddressString),
            let index = json["index"] as? Int32,
            let winLevel = json["winLevel"] as? Int32,
            let winAmountString = json["winAmount"] as? String,
            let winAmount = UInt256(hexString: winAmountString) else { return nil }
        
        self.playerAddress = playerAddress
        self.index = index
        self.winLevel = winLevel
        self.winAmount = winAmount
    }
}
