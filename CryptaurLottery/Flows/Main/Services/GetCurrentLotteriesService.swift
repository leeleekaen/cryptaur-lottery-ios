//
//  GetCurrentLotteriesService.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 19.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation

final class GetCurrentLotteriesService: OperationService<Void, GetCurrentLotteriesResponseModel> {
    override func createOperation(input: Void, success: @escaping ServiceSuccess, failure: @escaping ServiceFailure) -> Operation? {
        return GetCurrentLotteriesOperation(success: { (json) in
            guard let object = GetCurrentLotteriesResponseModel(json: json) else {
                failure(ServiceError.deserializationFailure)
                return
            }
            success(object)
        }, failure: failure)
    }
}

final fileprivate class GetCurrentLotteriesOperation: APIOperation {
    init(success: @escaping APIOperationSuccess, failure: @escaping ServiceFailure) {
        super.init(endpoint: .getCurrentLotteries, parameters: nil, headers: nil, success: success, failure: failure)
    }
}
