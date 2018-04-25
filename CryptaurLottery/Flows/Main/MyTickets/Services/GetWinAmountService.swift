import Foundation
import Alamofire
import UInt256

final class GetWinAmountService:
OperationService<GetWinAmountRequestModel, GetWinAmountResponceModel> {
    
    override func createOperation(input: GetWinAmountRequestModel,
                                  success: @escaping ServiceSuccess,
                                  failure: @escaping ServiceFailure) -> Operation? {
        
        return GetWinAmountOperation(request: input, success: { (json) in
            guard let object = GetWinAmountResponceModel(json: json) else {
                failure(ServiceError.deserializationFailure)
                return
            }
            success(object)
        }, failure: failure)
    }
}

fileprivate final class GetWinAmountOperation: APIOperation {
    
    init(request: GetWinAmountRequestModel,
         success: @escaping APIOperationSuccess,
         failure: @escaping ServiceFailure) {
        
        let parameters = ["playerAddress": "\(request.playerAddress.normalizedHexString)"]
        
        super.init(endpoint: .getWinAmount, parameters: parameters, headers: nil,
                   success: success, failure: failure)
    }
    
    override func URL(with endpoint: APIEndpoint) -> URLConvertible {
        
        guard let playerAddress = parameters?["playerAddress"] as? String else {
            return endpoint
        }
        
        guard var url = try? endpoint.asURL() else {
            return endpoint
        }
        url.appendPathComponent(playerAddress)
        return url
    }
}
