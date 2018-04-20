import Foundation
import UInt256

/*
request type: GET
url: api/getWinAmount/{playerAddress}
return:
{
    "winAmount": "0x203040" // величина выигрыша пользователя {playerAddress}, int256
    "pickUpWinGasFee": "0x203040" // комиссия за получения выигрыша, int256
}
*/

struct WinAmount {
    
    var winAmount: UInt256
    var pickUpWinGasFee: UInt256
    
    init() {
        winAmount = UInt256(integerLiteral: 0)
        pickUpWinGasFee = UInt256(integerLiteral: 0)
    }
    
    init?(json: JSONDictionary) {
        
        guard let winAmountString = json["winAmount"] as? String,
                let winAmount = UInt256(hexString: winAmountString),
                let pickUpWinGasFeeString = json["pickUpWinGasFee"] as? String,
                let pickUpWinGasFee = UInt256(hexString: pickUpWinGasFeeString)
            else {
                return nil
        }
        
        self.winAmount = winAmount
        self.pickUpWinGasFee = pickUpWinGasFee
    }
}
