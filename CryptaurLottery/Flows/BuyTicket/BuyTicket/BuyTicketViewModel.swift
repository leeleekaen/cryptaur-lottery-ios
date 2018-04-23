import Foundation
import RxSwift
import RxCocoa
import UInt256

class BuyTicketViewModel: BaseViewModel {
    
    // MARK: - Public properties
    let authKey: String = ""
    let lottery: LotteryID = .lottery5x36
    let drawIndex: Int  = 0
    let player: UInt256 = 0
    
    
    
    // MARK: - Dependency
    let buyTicketsService = BuyTicketsService()
    
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
