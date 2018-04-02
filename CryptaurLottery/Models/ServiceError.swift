//
//  ErrorDeclarations.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

enum ServiceError: Error {
    case InvalidOperation
    case Api(code: String, message: String?)
}
