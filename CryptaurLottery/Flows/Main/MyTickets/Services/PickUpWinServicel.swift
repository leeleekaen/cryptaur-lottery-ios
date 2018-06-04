import Foundation
import Alamofire

final class PickUpWinService:
OperationService<PickUpWinRequestModel, PickUpWinResponceModel> {
    
    override func createOperation(input: PickUpWinRequestModel,
                                  success: @escaping ServiceSuccess,
                                  failure: @escaping ServiceFailure) -> Operation? {
        
        return GetPlayerTicketsOperation(request: input, success: { (json) in
            guard let object = PickUpWinResponceModel(json: json) else {
                failure(ServiceError.deserializationFailure)
                return
            }
            success(object)
        }, failure: failure)
    }
}

fileprivate final class GetPlayerTicketsOperation: APIOperation {
    
    override func createRequest() -> DataRequest {
        
        return Alamofire.request(URL(with: endpoint),
                                 method: endpoint.method.asAlamofireMethod(),
                                 parameters: parameters,
                                 encoding: JSONEncoding.default,
                                 headers: headers)
    }
    
    init(request: PickUpWinRequestModel,
         success: @escaping APIOperationSuccess,
         failure: @escaping ServiceFailure) {
        
        let parameters = ["playerAddress": "\(request.playerAddress.normalizedHexString)"]
        
        let headers = [
            "Authorization": "Bearer \(request.authKey)",
            "Content-Type": "application/json"
        ]
        
        super.init(endpoint: .pickUpWin,
                   parameters: parameters, headers: headers,
                   success: success, failure: failure)
    }
}
