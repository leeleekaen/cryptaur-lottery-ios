import Foundation
import RxSwift
import RxCocoa
import UInt256
import KeychainSwift

class BuyTicketViewModel: BaseViewModel {
    
    // MARK: - Public properties
    var draw: Draw?
    
    var ticketPrice: Driver<UInt256> {
        return ticketPriceObject.asDriver(onErrorJustReturn: UInt256(integerLiteral: 10))
    }
    
    var buyTicketCompletion: ((String) -> ())?
    var sendErrorCompletion: (() -> ())?

    // MARK: - Private properties
    let ticketPriceObject = BehaviorSubject<UInt256>(value: UInt256(integerLiteral: 10))
    
    // MARK: - Dependency
    let buyTicketsService = BuyTicketsService()
    let getTicketPriceService = GetTicketPriceService()
    let keychain = KeychainSwift()
    
    // MARK: - Lifecycle
    override init() {
        super.init()
        getTicketPrice()
    }
    
    // MARK: - Public methods
    func buyTicket(numbers: [Int]) {
        
        guard let draw = draw,
            let lottery = LotteryID(rawValue: draw.lotteryID) else { return }
        
        let drawIndex = Int(draw.number)
        
        guard let authKey = keychain.get(PlayersKey.accessToken),
            let hexAddress = keychain.get(PlayersKey.address),
            let address = UInt256(hexString: hexAddress) else { return }
        
        let request = BuyTicketRequestModel(authKey: authKey, lottery: lottery,
                                            numbers: numbers, drawIndex: drawIndex,
                                            playerAddress: address)
       
        
        buyTicketsService.perform(input: request,
                                  success: { [weak self] in
                                    self?.buyTicketCompletion?($0.trxHash)
                                    
            }, failure: { [weak self] error in
                self?.errorSubject.onNext(error)
                self?.sendErrorCompletion?()
        })
    }
}

// MARK: - Private methods
private extension BuyTicketViewModel {
    func getTicketPrice() {
        
        guard let draw = draw,
            let lottery = LotteryID(rawValue: draw.lotteryID) else {return }
        
        let request = GetTicketPriceRequestModel(lotteryID: lottery)
        
        getTicketPriceService.perform(input: request,
                               success: { [weak self] (responce) in
                                self?.ticketPriceObject.onNext(responce.price)
            }, failure: defaultServiceFailure)
    }
}
