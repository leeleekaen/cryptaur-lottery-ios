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

        let components = strings.compactMap { UInt64($0, radix: 16) }

        guard components.count == 4 else {
            return nil
        }

        self.init(components)
    }

    var normalizedHexString: String {

        var str = self.toHexString()

        var currentChar: Character = "0"
        while currentChar == "0" {
            if str.isEmpty {
                return "0x"
            } else {
                currentChar = str.removeFirst()
            }
        }

        return "0x" + String(currentChar) + str
    }

    func toString() -> String  {
        let words = self.words
        var retVal = ""
        for word in words {
            retVal = retVal + "\(word)"
        }
        return retVal
    }

    func toStringWithDelimeters() -> String  {
        
        guard self != UInt256(integerLiteral: 0) else {
            return "0"
        }
        
        let s = toString()
        let endIndex = s.endIndex
        var retVal = "." + s[s.index(endIndex, offsetBy: -8)...]
        var offset = -8
        var addComma = false
        var previousLeftIndex: String.Index? = nil
        var digitsCount = 8
        repeat {
            offset -= 3
            if let leftIndex = s.index(endIndex, offsetBy: offset, limitedBy: s.startIndex) {
                let prepend = s[leftIndex..<s.index(endIndex, offsetBy: offset + 3)]
                retVal = String(prepend) + (addComma ? "," : "") + retVal
                previousLeftIndex = leftIndex
                digitsCount += 3
            }
            else {
                guard previousLeftIndex != nil else {
                    return s
                }
                let prepend = s[s.startIndex..<s.index(s.startIndex, offsetBy: s.count - digitsCount)]
                retVal = String(prepend) + (addComma ? "," : "") + retVal
            }
            addComma = true
        } while -offset < s.count
        return retVal
    }
}
