import Foundation

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
    
    init(request: PickUpWinRequestModel,
         success: @escaping APIOperationSuccess,
         failure: @escaping ServiceFailure) {
        
        let parameters = ["playerAddress": "\(request.playerAddress.normalizedHexString)"]
        
        super.init(endpoint: .connect, parameters: parameters, headers: ["Authorization": "Bearer \(request.authKey)"], success: success, failure: failure)
    }
}
