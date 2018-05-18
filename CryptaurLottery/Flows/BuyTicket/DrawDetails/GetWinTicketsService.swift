import Foundation
import Alamofire
import UInt256

final class GetWinTicketsService:
OperationService<GetWinTicketsRequestModel, GetWinTicketsResponceModel> {
    
    override func createOperation(input: GetWinTicketsRequestModel,
                                  success: @escaping ServiceSuccess,
                                  failure: @escaping ServiceFailure) -> Operation? {
        
        return GetWinTicketsOperation(request: input, success: { (json) in
            guard let object = GetWinTicketsResponceModel(json: json) else {
                failure(ServiceError.deserializationFailure)
                return
            }
            success(object)
        }, failure: failure)
    }
}

fileprivate final class GetWinTicketsOperation: APIOperation {
    
    init(request: GetWinTicketsRequestModel,
         success: @escaping APIOperationSuccess,
         failure: @escaping ServiceFailure) {
        
        let parameters = [
            "lotteryID": "\(request.lotteryID.rawValue)",
            "drawIndex": "\(request.drawIndex)",
            "offset": "\(request.offset)",
            "count": "\(request.count)"
        ]
        
        super.init(endpoint: .getWinTickets, parameters: parameters, headers: nil,
                   success: success, failure: failure)
    }
    
    override func URL(with endpoint: APIEndpoint) -> URLConvertible {
        
        guard let lotteryID = parameters?["lotteryID"] as? String,
            let drawIndex = parameters?["drawIndex"] as? String,
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
        url.appendPathComponent(drawIndex)
        url.appendPathComponent(offset)
        url.appendPathComponent(count)
        
        return url
    }
}
