// Copyright 2024 Aiuta USA, Inc
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

@_spi(Aiuta) public extension String {
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
