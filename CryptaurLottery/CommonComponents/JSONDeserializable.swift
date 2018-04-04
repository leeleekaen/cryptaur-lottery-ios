//
//  JSONDeserializable.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 04.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

typealias JSONDictionary = [String: Any]

protocol JSONDeserializable {
    init?(json: JSONDictionary)
}
