import Foundation
import Alamofire

final class GetDrawsService:
OperationService<GetDrawsRequestModel, GetDrawsResponceModel> {
    
    override func createOperation(input: GetDrawsRequestModel,
                                  success: @escaping ServiceSuccess,
                                  failure: @escaping ServiceFailure) -> Operation? {
        
        return GetDrawsOperation(request: input,
                                 success: { (json) in
                                    
            guard let object = GetDrawsResponceModel(json: json) else {
                failure(ServiceError.deserializationFailure)
                return
            }
            success(object)
                                    
        }, failure: failure)
    }
}

final fileprivate class GetDrawsOperation: APIOperation {
    
    init(request: GetDrawsRequestModel,
         success: @escaping APIOperationSuccess,
         failure: @escaping ServiceFailure) {
        
        let parameters =
            ["lotteryID": "\(request.lotteryID.rawValue)",
                "offset": "\(request.offset)",
                "count": "\(request.count)"]
        
        
        super.init(endpoint: .getDraws, parameters: parameters, headers: nil,
                   success: success, failure: failure)
    }
    
    override func URL(with endpoint: APIEndpoint) -> URLConvertible {
        
        guard let lotteryID = parameters?["lotteryID"] as? String,
            let offset = parameters?["offset"] as? String,
            let count = parameters?["count"] as? String else {
                return endpoint
        }
        
        guard var url = try? endpoint.asURL() else {
            return endpoint
        }
        
        url.appendPathComponent(lotteryID)
        url.appendPathComponent(offset)
        url.appendPathComponent(count)
        
        return url
    }
}
