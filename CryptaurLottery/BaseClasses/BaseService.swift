//
//  BaseService.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation

typealias ServiceFailure = (ServiceError) -> ()

class BaseService<Input, Output> {
    typealias ServiceSuccess = (Output) -> ()
    
    final let operationQueue = OperationQueue()
    
    func createOperation(input: Input, success: ServiceSuccess, failure: ServiceFailure) -> Operation? {
        fatalError("Must implement `createOperation(input:success:failure:)`")
    }
    
    final func perform(input: Input, success: ServiceSuccess, failure: ServiceFailure) {
        guard let operation = createOperation(input: input, success: success, failure: failure) else {
            failure(ServiceError.InvalidOperation)
            return
        }
        operationQueue.addOperation(operation)
    }
}

