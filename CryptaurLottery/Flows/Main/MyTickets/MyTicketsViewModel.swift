import Foundation

class MyTicketsViewModel: BaseViewModel {
    
    var winAmount: WinAmount?
    
    override init() {
        super.init()
        
        let json = getWinAmountJson()
        winAmount = WinAmount(json: json)
    }
    
    private func getWinAmountJson() -> JSONDictionary {
        return ["winAmount": "0x203040",
                "pickUpWinGasFee": "0x203040"]
    }
}
