import Foundation
import RxSwift
import RxCocoa
import UInt256

class BuyTicketViewModel: BaseViewModel {
    
    // MARK: - Public properties
    let authKey: String = ""
    var lottery: LotteryID?
    let drawIndex: Int  = 0
    let player: UInt256 = UInt256(hexString: "0x172d3f8FD5b0e9e4D5aAEf352386D895047d905B")!
    
    var balance: Driver<UInt256> {
        return balanceObject.asDriver(onErrorJustReturn: UInt256(integerLiteral: 0))
    }
    
    var ticketPrice: Driver<UInt256> {
        return ticketPriceObject.asDriver(onErrorJustReturn: UInt256(integerLiteral: 10))
    }
    
    
    // MARK: - Private properties
    let balanceObject = BehaviorSubject<UInt256>(value: UInt256(integerLiteral: 0))
    let ticketPriceObject = BehaviorSubject<UInt256>(value: UInt256(integerLiteral: 10))
    
    // MARK: - Dependency
    let buyTicketsService = BuyTicketsService()
    let balanceService = GetPlayerAviableBalanceService()
    let getTicketPriceService = GetTicketPriceService()
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        
        getBalance()
        getTicketPrice()
    }
    
    // MARK: - Public methods
    func buyTicket(numbers: [Int]) {
        
        guard let lottery = lottery else { return }
        
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
                               success: { [weak self] (responce) in
                                self?.balanceObject.onNext(responce.balance)
        }, failure: defaultServiceFailure)
    }
    
    func getTicketPrice() {
        
        guard let lottery = lottery else { return }
        
        let request = GetTicketPriceRequestModel(lotteryID: lottery)
        getTicketPriceService.perform(input: request,
                               success: { [weak self] (responce) in
                                self?.ticketPriceObject.onNext(responce.price)
            }, failure: defaultServiceFailure)
    }
}
