import Foundation

final class BuyTicketsService:
OperationService<BuyTicketRequestModel, BuyTicketResponceModel> {
    
    override func createOperation(input: BuyTicketRequestModel,
                                  success: @escaping ServiceSuccess,
                                  failure: @escaping ServiceFailure) -> Operation? {
        
        return BuyTicketOperation(request: input, success: { (json) in
            guard let object = BuyTicketResponceModel(json: json) else {
                failure(ServiceError.deserializationFailure)
                return
            }
            success(object)
        }, failure: failure)
    }
}

fileprivate final class BuyTicketOperation: APIOperation {
    
    init(request: BuyTicketRequestModel,
         success: @escaping APIOperationSuccess,
         failure: @escaping ServiceFailure) {
        
        let parameters = ["lotteryId": request.lottery.rawValue,
                          "numbers": request.numbers,
                          "drawIndex": request.drawIndex,
                          "address": request.playerAddress] as [String : Any]
        
        
        super.init(endpoint: .connect, parameters: parameters, headers: ["Authorization": "Bearer \(request.authKey)"], success: success, failure: failure)
    }
}
