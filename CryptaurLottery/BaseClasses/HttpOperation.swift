//
//  HttpOperation.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 02.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation
import Alamofire

class HttpOperation: Operation {
    let endpoint: HttpEndpoint
    let parameters: Any?
    
    init(endpoint: HttpEndpoint, parameters: Any? = nil) {
        self.endpoint = endpoint
        self.parameters = parameters
        super.init()
    }
    
    override func main() {
        // TODO
    }
}
