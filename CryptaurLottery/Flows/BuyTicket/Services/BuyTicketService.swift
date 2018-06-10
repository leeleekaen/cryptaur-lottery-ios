import Foundation
import Alamofire

final class BuyTicketsService:
OperationService<BuyTicketRequestModel, BuyTicketResponceModel> {
    
    override func createOperation(input: BuyTicketRequestModel,
                                  success: @escaping ServiceSuccess,
                                  failure: @escaping ServiceFailure) -> Operation? {
        
        return BuyTicketOperation(request: input, success: { (json) in
            print("\(json)")
            guard let object = BuyTicketResponceModel(json: json) else {
                failure(ServiceError.deserializationFailure)
                return
            }
            success(object)
        }, failure: failure)
    }
}

fileprivate final class BuyTicketOperation: APIOperation {
    
    override func createRequest() -> DataRequest {
        
        return Alamofire.request(URL(with: endpoint),
                                 method: endpoint.method.asAlamofireMethod(),
                                 parameters: parameters,
                                 encoding: JSONEncoding.default,
                                 headers: headers)
    }
    
    init(request: BuyTicketRequestModel,
         success: @escaping APIOperationSuccess,
         failure: @escaping ServiceFailure) {
        
        let parameters = ["lotteryId": request.lottery.rawValue,
                          "numbers": request.numbers,
                          "drawIndex": request.drawIndex,
                          "address": request.playerAddress.normalizedHexString] as [String : Any]
        
         print("\(parameters)")
        
        let headers = [
            "Authorization": "Bearer \(request.authKey)",
            "Content-Type": "application/json"
        ]
        
        super.init(endpoint: .buyTickets,
                   parameters: parameters,
                   headers: headers,
                   success: success, failure: failure)
    }
}
