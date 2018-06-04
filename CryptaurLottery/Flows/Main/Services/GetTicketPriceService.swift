//
//  GetTicketPriceService.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 04.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation
import Alamofire

final class GetTicketPriceService: OperationService<GetTicketPriceRequestModel, GetTicketPriceResponseModel> {
    override func createOperation(input: GetTicketPriceRequestModel, success: @escaping ServiceSuccess, failure: @escaping ServiceFailure) -> Operation? {
        return GetTicketPriceOperation(request: input, success: { (json) in
            guard let object = GetTicketPriceResponseModel(json: json) else {
                failure(ServiceError.deserializationFailure)
                return
            }
            success(object)
        }, failure: failure)
    }
}

fileprivate final class GetTicketPriceOperation: APIOperation {
    init(request: GetTicketPriceRequestModel, success: @escaping APIOperationSuccess, failure: @escaping ServiceFailure) {
        let parameters = ["lotteryID": "\(request.lotteryID.rawValue)"]
        super.init(endpoint: .getTicketPrice, parameters: parameters, headers: nil, success: success, failure: failure)
    }
    
    override func URL(with endpoint: APIEndpoint) -> URLConvertible {
        guard let lotteryID = parameters?["lotteryID"] as? String else {
            return endpoint
        }
        guard var url = try? endpoint.asURL() else {
            return endpoint
        }
        url.appendPathComponent(lotteryID)
        return url
    }
}
