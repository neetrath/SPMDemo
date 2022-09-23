import Foundation

public extension Character {
    fileprivate func isEmoji() -> Bool {
        return Character(UnicodeScalar(UInt32(0x1D000))!) <= self && self <= Character(UnicodeScalar(UInt32(0x1F77F))!)
            || Character(UnicodeScalar(UInt32(0x2100))!) <= self && self <= Character(UnicodeScalar(UInt32(0x26FF))!)
    }
}

public extension String {
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    func isEmpty() -> Bool {
        if count > 0 {
            return false
        } else {
            return true
        }
    }

    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }

    var pathExtension: String {
        return (self as NSString).pathExtension
    }

    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }

    func stringByAppendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString
        return nsSt.appendingPathExtension(ext)
    }

    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }

    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    func subString(startIndex: Int, endIndex: Int) -> String {
        let end = (endIndex - count) + 1
        let indexStartOfText = index(self.startIndex, offsetBy: startIndex)
        let indexEndOfText = index(self.endIndex, offsetBy: end)
        let substring = self[indexStartOfText ..< indexEndOfText]
        return String(substring)
    }

    func split(separator: String) -> [String] {
        return components(separatedBy: separator)
    }

    // MARK: - replace

    func replaceCharactersInRange(range: Range<Int>, withString: String!) -> String {
        let result: NSMutableString = NSMutableString(string: self)
        result.replaceCharacters(in: NSRange(range), with: withString)
        return result as String
    }

    func index(from: Int) -> Index {
        return index(startIndex, offsetBy: from)
    }

    func removeEmoji() -> String {
        return String(filter { !$0.isEmoji() })
    }

    func removeCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }

    func removeCharacters(from: String) -> String {
        return removeCharacters(from: CharacterSet(charactersIn: from))
    }

    func padLeft(totalWidth: Int, with: String) -> String {
        let toPad = totalWidth - count
        if toPad < 1 { return self }
        return "".padding(toLength: toPad, withPad: with, startingAt: 0) + self
    }
}

public extension String {
    /// Create `Data` from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a `Data` object. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.

    func hexadecimal() -> Data? {
        var data = Data(capacity: count / 2)

        do {
            let regex = try NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
            regex.enumerateMatches(in: self, options: [], range: NSRange(location: 0, length: count)) { match, _, _ in
                let byteString = (self as NSString).substring(with: match!.range)
                var num = UInt8(byteString, radix: 16)!
                data.append(&num, count: 1)
            }

            guard data.count > 0 else {
                return nil
            }

            return data
        } catch {
            return nil
        }
    }
}

public extension String {
    /// Create `String` representation of `Data` created from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a String object from that. Note, if the string has any spaces, those are removed. Also if the string started with a `<` or ended with a `>`, those are removed, too.
    ///
    /// For example,
    ///
    ///     String(hexadecimal: "<666f6f>")
    ///
    /// is
    ///
    ///     Optional("foo")
    ///
    /// - returns: `String` represented by this hexadecimal string.

    init?(hexadecimal string: String) {
        guard let data = string.hexadecimal() else {
            return nil
        }

        self.init(data: data, encoding: .utf8)
    }

    /// Create hexadecimal string representation of `String` object.
    ///
    /// For example,
    ///
    ///     "foo".hexadecimalString()
    ///
    /// is
    ///
    ///     Optional("666f6f")
    ///
    /// - parameter encoding: The `NSStringCoding` that indicates how the string should be converted to `NSData` before performing the hexadecimal conversion.
    ///
    /// - returns: `String` representation of this String object.

    func hexadecimalString() -> String? {
        return data(using: .utf8)?
            .hexadecimal()
    }
}

public extension Data {
    /// Create hexadecimal string representation of `Data` object.
    ///
    /// - returns: `String` representation of this `Data` object.

    func hexadecimal() -> String {
        return map { String(format: "%02x", $0) }
            .joined(separator: "")
    }
}
