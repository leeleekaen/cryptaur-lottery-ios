//
//  OperationService.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation

typealias ServiceFailure = (Error) -> ()

class OperationService<Input, Output: JSONDeserializable> {
    typealias ServiceSuccess = (Output) -> ()
    
    final let operationQueue = OperationQueue()
    
    final func perform(input: Input, success: @escaping ServiceSuccess, failure: @escaping ServiceFailure) {
        guard let operation = createOperation(input: input, success: success, failure: failure) else {
            failure(ServiceError.invalidOperation)
            return
        }
        operationQueue.addOperation(operation)
    }
    
    func createOperation(input: Input, success: @escaping ServiceSuccess, failure: @escaping ServiceFailure) -> Operation? {
        return nil
    }
}
