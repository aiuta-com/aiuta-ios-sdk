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

import UIKit

extension Aiuta.Configuration {
    /// Represents a color value used in the Aiuta SDK configuration.
    ///
    /// Supported underlying representations:
    /// - `.argb` — 32-bit ARGB in the form `0xAARRGGBB`
    /// - `.rgb`  — 24-bit RGB in the form `0xRRGGBB` (alpha assumed to be `0xFF`)
    /// - `.ui`   — a concrete `UIColor`
    public enum Color {
        case argb(UInt32)
        case rgb(UInt32)
        case ui(UIColor)
    }
}

// MARK: - Literal support

extension Aiuta.Configuration.Color: ExpressibleByIntegerLiteral {
    /// Initializes from an integer literal representing a hex color.
    ///
    /// Supported forms (without any separators or prefixes at the call site):
    /// - `0xRGB`       → treated as `.rgb(0xRRGGBB)` by expanding each nibble
    /// - `0xARGB`      → treated as `.argb(0xAARRGGBB)` by expanding each nibble
    /// - `0xRRGGBB`    → `.rgb(0xRRGGBB)`
    /// - `0xAARRGGBB`  → `.argb(0xAARRGGBB)`
    ///
    /// If the value cannot be parsed, defaults to `.ui(.clear)`.
    public init(integerLiteral value: UInt64) {
        let hex = String(value, radix: 16)

        guard let color = try? Self.parseHexString(hex) else {
            self = .ui(.clear)
            return
        }
        self = color
    }
}

extension Aiuta.Configuration.Color: ExpressibleByStringLiteral {
    /// Initializes from a hex color string literal.
    ///
    /// Supported formats (case-insensitive, optional `#` or `0x` prefix):
    /// - `"#AARRGGBB"`, `"AARRGGBB"`, `"0xAARRGGBB"`
    /// - `"#RRGGBB"`,  `"RRGGBB"`,  `"0xRRGGBB"` (alpha assumed to be `FF`)
    /// - Short forms `"#ARGB"` and `"#RGB"` are also accepted via expansion
    ///
    /// If the value cannot be parsed, defaults to `.ui(.clear)`.
    public init(stringLiteral value: String) {
        guard let color = try? Self.parseHexString(value) else {
            self = .ui(.clear)
            return
        }
        self = color
    }
}

// MARK: - Hex string parsing

extension Aiuta.Configuration.Color {
    /// Errors that can occur while parsing a color from a hex string.
    public enum ParseError: Error {
        case invalidFormat(String)
    }

    /// Initializes a color from a hex string.
    ///
    /// Supported formats (case-insensitive):
    /// - `"#AARRGGBB"`, `"AARRGGBB"`, `"0xAARRGGBB"`
    /// - `"#RRGGBB"`,  `"RRGGBB"`,  `"0xRRGGBB"` (alpha assumed to be `FF`)
    /// - Short forms `"#ARGB"` and `"#RGB"` are expanded to `AARRGGBB`/`RRGGBB`
    ///
    /// Components: `A` — alpha, `R` — red, `G` — green, `B` — blue.
    init(hexString: String) throws {
        let color = try Self.parseHexString(hexString)
        self = color
    }

    /// Internal parser that converts a hex string into a `Color` representation.
    static func parseHexString(_ string: String) throws -> Aiuta.Configuration.Color {
        var s = string.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if s.hasPrefix("#") {
            s.removeFirst()
        } else if s.hasPrefix("0x") {
            s.removeFirst(2)
        }

        let hexSet = CharacterSet(charactersIn: "0123456789abcdef")
        let allHex = s.unicodeScalars.allSatisfy { scalar in
            hexSet.contains(scalar)
        }

        guard allHex else {
            throw ParseError.invalidFormat(string)
        }

        switch s.count {
            case 3:
                // RGB → expand to RRGGBB
                let chars = Array(s)
                let r = chars[0]
                let g = chars[1]
                let b = chars[2]
                s = "\(r)\(r)\(g)\(g)\(b)\(b)"
                guard let value = UInt32(s, radix: 16) else {
                    throw ParseError.invalidFormat(string)
                }
                return .rgb(value)

            case 4:
                // ARGB → expand to AARRGGBB
                let chars = Array(s)
                let a = chars[0]
                let r = chars[1]
                let g = chars[2]
                let b = chars[3]
                s = "\(a)\(a)\(r)\(r)\(g)\(g)\(b)\(b)"
                guard let value = UInt32(s, radix: 16) else {
                    throw ParseError.invalidFormat(string)
                }
                return .argb(value)

            case 6:
                // RRGGBB
                guard let value = UInt32(s, radix: 16) else {
                    throw ParseError.invalidFormat(string)
                }
                return .rgb(value)

            case 8:
                // AARRGGBB
                guard let value = UInt32(s, radix: 16) else {
                    throw ParseError.invalidFormat(string)
                }
                return .argb(value)

            default:
                throw ParseError.invalidFormat(string)
        }
    }
}
