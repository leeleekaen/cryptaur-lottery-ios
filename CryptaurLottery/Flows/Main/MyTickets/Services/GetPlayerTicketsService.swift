import Foundation
import Alamofire
import UInt256


final class GetPlayerTicketsService:
OperationService<GetPlayerTicketsRequestModel, GetPlayerTicketsResponceModel> {
    
    override func createOperation(input: GetPlayerTicketsRequestModel,
                                  success: @escaping ServiceSuccess,
                                  failure: @escaping ServiceFailure) -> Operation? {
        
        return GetPlayerTicketsOperation(request: input, success: { (json) in
            guard let object = GetPlayerTicketsResponceModel(json: json) else {
                failure(ServiceError.deserializationFailure)
                return
            }
            success(object)
        }, failure: failure)
    }
}

fileprivate final class GetPlayerTicketsOperation: APIOperation {
    
    init(request: GetPlayerTicketsRequestModel,
         success: @escaping APIOperationSuccess,
         failure: @escaping ServiceFailure) {
        
        let parameters = [
            "lotteryID": "\(request.lotteryID.rawValue)",
            "playerAddress": "\(request.playerAddress.normalizedHexString)",
            "offset": "\(request.offset)",
            "count": "\(request.count)"
        ]
        
        super.init(endpoint: .getPlayerTickets, parameters: parameters, headers: nil,
                   success: success, failure: failure)
    }
    
    override func URL(with endpoint: APIEndpoint) -> URLConvertible {
        
        guard let lotteryID = parameters?["lotteryID"] as? String,
                let playerAddress = parameters?["playerAddress"] as? String,
                let offset = parameters?["offset"] as? String,
                let count = parameters?["count"] as? String else {
                    print("Can't get parameters")
                    return endpoint
        }
        
        guard var url = try? endpoint.asURL() else {
            print("Can't create url")
            return endpoint
        }
        
        url.appendPathComponent(lotteryID)
        url.appendPathComponent(playerAddress)
        url.appendPathComponent(offset)
        url.appendPathComponent(count)
                
        return url
    }
}
