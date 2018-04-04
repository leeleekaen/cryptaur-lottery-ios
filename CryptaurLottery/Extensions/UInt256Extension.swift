//
//  UInt256Extension.swift
//  CryptaurLottery
//
//  Created by Alexander Polyakov on 04.04.2018.
//  Copyright © 2018 Nordavind. All rights reserved.
//

import Foundation
import UInt256

fileprivate extension String {
    func padded(to width: Int, with character: Character) -> String? {
        guard width > 0 && self.count > 0 && self.count <= width else {
            return nil
        }
        
        var string = self
        
        if string.count < width {
            for _ in 1...(width - string.count) {
                string = "\(character)" + string
            }
        }
        return string
    }
    
    func removeHexPrefixIfNeeded() -> String {
        var hexString = self
        if hexString.prefix(2).uppercased() == "0X" {
            hexString = String(hexString.dropFirst(2))
        }
        return hexString
    }
}

extension UInt256 {
    init?(hexString: String) {
        guard let s = hexString.removeHexPrefixIfNeeded().padded(to: 64, with: "0")?.uppercased() else {
            return nil
        }
        
        let startIndex = s.startIndex
        
        let subStrings: [Substring] = [
            s[startIndex..<s.index(startIndex, offsetBy: 16)],
            s[s.index(startIndex, offsetBy: 16)..<s.index(startIndex, offsetBy: 32)],
            s[s.index(startIndex, offsetBy: 32)..<s.index(startIndex, offsetBy: 48)],
            s[s.index(startIndex, offsetBy: 48)...]
        ]
        let strings = subStrings.map { String($0) }
        
        let components = strings.flatMap { UInt64($0, radix: 16) }
        
        guard components.count == 4 else {
            return nil
        }
        
        self.init(components)
    }
}
