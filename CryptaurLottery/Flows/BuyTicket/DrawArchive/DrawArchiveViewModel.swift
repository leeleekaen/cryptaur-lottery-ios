import Foundation
import RxSwift
import RxCocoa

class DrawArchiveViewModel: BaseViewModel {
    
    // MARK: - Public properties
    var draws = [ArchiveDraw]()
    var updateCompletion: (() -> ())?
    var isLoading: Driver<Bool> {
        return isLoadingObject.asDriver(onErrorJustReturn: false)
    }
    
    // MARK: - Private properties
    private let lottery: LotteryID = .lottery5x36
    private let isLoadingObject = BehaviorSubject<Bool>(value: false)
    
    // MARK: - Dependencies
    let service = GetDrawsService()
    
    // MARK: - Lificycle
    override init() {
        super.init()
        getNextDraws()
    }
    
    // MARK: - Public methods
    func getNextDraws() {
        
        guard let isLoadingValue = try? isLoadingObject.value() else { return }
        
        if !isLoadingValue {
            if draws.count == 0 || draws.last!.number != 1 {
                isLoadingObject.onNext(true)
                getDraws(offset: UInt(draws.count + 1), count: 50)
            }
        }
    }
}

// MARK: - Private methods
private extension DrawArchiveViewModel {
    func getDraws(offset: UInt, count: UInt) {
        
        let request = GetDrawsRequestModel(lotteryID: lottery, offset: offset, count: count)
        print("request: \(request)")
        
        service.perform(input: request,
                        success: { [weak self] (responce) in
                            
                            var archiveDraws = [ArchiveDraw]()
                            responce.draws.forEach {
                                if $0.numbers.count > 0 {
                                    archiveDraws.append($0)
                                }
                            }
                            self?.draws += archiveDraws
                            self?.updateCompletion?()
                            self?.isLoadingObject.onNext(false)
                            
        }) { [weak self] (error) in
            self?.errorSubject.onNext(error)
            print(error)
            self?.isLoadingObject.onNext(false)
        }
    }
}
