//
//  NSObject+ClassName.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 06.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation

extension NSObject {
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
