import Foundation

class DrawArchiveViewModel: BaseViewModel {
    
    let lottery: LotteryID = .lottery4x20
    
    let service = GetDrawsService()
    
    override init() {
        super.init()
        
        getDraws()
    }
    
    func getDraws() {
        getDraws(offset: 0, count: 10)
    }
    
    func getDraws(offset: UInt, count: UInt) {
        
        let request = GetDrawsRequestModel(lotteryID: lottery, offset: offset, count: count)
    
        service.perform(input: request,
                        success: { (responce) in
                            print(responce)
        }, failure: defaultServiceFailure)
    }
}
