import Foundation

class DrawArchiveViewModel: BaseViewModel {
    
    var draws = [ArchiveDraw]()
    let lottery: LotteryID = .lottery5x36
    var updateCompletion: (() -> ())?
    
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
                        success: { [weak self] (responce) in
                            
                            var archiveDraws = [ArchiveDraw]()
                            responce.draws.forEach {
                                if let numbers = $0.numbers, numbers.count > 0 {
                                    archiveDraws.append($0)
                                }
                            }
                            self?.draws = archiveDraws
                            self?.updateCompletion?()
                            
        }, failure: defaultServiceFailure)
    }
}
