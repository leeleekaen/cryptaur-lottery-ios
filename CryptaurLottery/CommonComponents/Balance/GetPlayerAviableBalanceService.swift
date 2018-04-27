import Foundation
import UInt256
import Alamofire

final class GetPlayerAviableBalanceService:
    OperationService<GetPlayerAviableBalanceRequestModel, GetPlayerAviableBalanceResponceModel> {
    
    override func createOperation(input: GetPlayerAviableBalanceRequestModel,
                                  success: @escaping ServiceSuccess,
                                  failure: @escaping ServiceFailure) -> Operation? {
        
        return GetPlayerAviableBalanceOperation(request: input, success: { (json) in
            guard let object = GetPlayerAviableBalanceResponceModel(json: json) else {
                failure(ServiceError.deserializationFailure)
                return
            }
            success(object)
        }, failure: failure)
    }
}


fileprivate final class GetPlayerAviableBalanceOperation: APIOperation {
    
    init(request: GetPlayerAviableBalanceRequestModel,
         success: @escaping APIOperationSuccess,
         failure: @escaping ServiceFailure) {
        
        let set = CharacterSet(charactersIn: "0")
        let address = "0x" + request.address.toHexString().trimmingCharacters(in: set)
        let parameters = ["address": address]
        super.init(endpoint: .getPlayerAviableBalance, parameters: parameters, headers: nil,
                   success: success, failure: failure)
    }
    
    override func URL(with endpoint: APIEndpoint) -> URLConvertible {
        
        guard let address = parameters?["address"] as? String else {
            return endpoint
        }
        guard var url = try? endpoint.asURL() else {
            return endpoint
        }
        url.appendPathComponent(address)
        return url
    }
}
