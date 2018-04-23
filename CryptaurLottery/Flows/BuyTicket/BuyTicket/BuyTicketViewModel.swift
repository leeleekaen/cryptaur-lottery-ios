import Foundation
import RxSwift
import RxCocoa
import UInt256

class BuyTicketViewModel: BaseViewModel {
    
    // MARK: - Public properties
    let authKey: String = ""
    let lottery: LotteryID = .lottery5x36
    let drawIndex: Int  = 0
    let player: UInt256 = UInt256(hexString: "0x172d3f8FD5b0e9e4D5aAEf352386D895047d905B")!
    var balance: Driver<UInt256> {
        return balanceObject.asDriver(onErrorJustReturn: UInt256(integerLiteral: 0))
    }
    
    // MARK: - Private properties
    let balanceObject = BehaviorSubject<UInt256>(value: UInt256(integerLiteral: 0))
    
    // MARK: - Dependency
    let buyTicketsService = BuyTicketsService()
    let balanceService = GetPlayerAviableBalanceService()
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        
        getBalance()
    }
    
    // MARK: - Public methods
    func buyTicket(numbers: [Int]) {
        
        let request = BuyTicketRequestModel(authKey: authKey, lottery: lottery,
                                            numbers: numbers, drawIndex: drawIndex,
                                            playerAddress: player)
        
        buyTicketsService.perform(input: request,
                        success: { (responce) in
                            print(responce)
        }, failure: defaultServiceFailure)
    }
}

// MARK: - Private methods
private extension BuyTicketViewModel {
    
    func getBalance() {
        
        let request = GetPlayerAviableBalanceRequestModel(address: player)
        balanceService.perform(input: request,
                               success: { (responce) in
                                print(responce)
        }) { (error) in
            print(error)
        }
    }
}
