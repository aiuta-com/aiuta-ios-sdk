//
// Created by nGrey on 02.02.2023.
//

import Foundation

public extension String {
    static let Empty: String = ""

    func appending(path: String) -> String {
        (self as NSString).appendingPathComponent(path)
    }

    func deletingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }

    func deletingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }

    var firstCapitalized: String {
        prefix(1).capitalized + dropFirst()
    }

    func attributed(with attributes: [NSAttributedString.Key: Any]?) -> NSAttributedString {
        NSAttributedString(string: self, attributes: attributes)
    }

    func mutableAttributed(with attributes: [NSAttributedString.Key: Any]?) -> NSMutableAttributedString {
        NSMutableAttributedString(string: self, attributes: attributes)
    }

    var base64String: String {
        Data(utf8).base64EncodedString()
    }

    func escapeJSONSpecialCharacters() -> String {
        let specialCharacters = [
            "“": "\"",
            "”": "\"",
            "‘": "\'",
            "’": "\'",
            "\0": "\\0",
            "\t": "\\t",
            "\n": "\\n",
            "\r": "\\r",
        ]
        return specialCharacters.reduce(self) { result, symbol in
            result.replacingOccurrences(of: symbol.key, with: symbol.value)
        }
    }

    var nsString: NSString {
        NSString(string: self)
    }
}
