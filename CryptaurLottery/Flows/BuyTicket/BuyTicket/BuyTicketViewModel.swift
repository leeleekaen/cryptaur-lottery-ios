import Foundation
import RxSwift
import RxCocoa
import UInt256
import KeychainSwift

class BuyTicketViewModel: BaseViewModel {
    
    // MARK: - Public properties
    var lottery: LotteryID?
    let drawIndex: Int  = 1
    
    var balance = UInt256(integerLiteral: 0)
    
    var ticketPrice: Driver<UInt256> {
        return ticketPriceObject.asDriver(onErrorJustReturn: UInt256(integerLiteral: 10))
    }
    
    
    // MARK: - Private properties
    let ticketPriceObject = BehaviorSubject<UInt256>(value: UInt256(integerLiteral: 10))
    
    // MARK: - Dependency
    let buyTicketsService = BuyTicketsService()
    let balanceService = GetPlayerAviableBalanceService()
    let getTicketPriceService = GetTicketPriceService()
    let keychain = KeychainSwift()
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        
        getBalance()
        getTicketPrice()
    }
    
    // MARK: - Public methods
    func buyTicket(numbers: [Int]) {
        
        guard let lottery = lottery,
            let authKey = keychain.get(PlayersKey.accessToken),
            let hexAddress = keychain.get(PlayersKey.address),
            let address = UInt256(hexString: hexAddress) else { return }
        
        let request = BuyTicketRequestModel(authKey: authKey, lottery: lottery,
                                            numbers: numbers, drawIndex: drawIndex,
                                            playerAddress: address)
        
        buyTicketsService.perform(input: request,
                                  success: { print($0) },
                                  failure: defaultServiceFailure)
    }
}

// MARK: - Private methods
private extension BuyTicketViewModel {
    
    func getBalance() {
        
        guard let hexAddress = keychain.get(PlayersKey.address),
            let address = UInt256(hexString: hexAddress) else { return }
        
        let request = GetPlayerAviableBalanceRequestModel(address: address)
        
        balanceService.perform(input: request,
                               success: { [weak self] (responce) in
                                self?.balance = responce.balance
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
