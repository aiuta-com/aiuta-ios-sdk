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
    /// A color value used by the Aiuta SDK configuration.
    ///
    /// `Color` is a lightweight wrapper around `UIColor` designed for use in
    /// configuration and theming APIs. It supports both compile-time literals
    /// and runtime values while providing safe fallback behavior.
    ///
    /// You can construct a `Color` from:
    /// - A `UIColor` instance
    /// - Hex color strings in ARGB/RGB form (see `init(hex:)`)
    /// - Hex color literals via `ExpressibleByStringLiteral` and
    ///   `ExpressibleByIntegerLiteral`
    ///
    /// Supported hex formats include:
    /// - `#RGB`, `#ARGB`
    /// - `#RRGGBB`, `#AARRGGBB`
    /// - Optional `#` or `0x` prefixes (case-insensitive)
    ///
    /// If a value cannot be parsed, the color safely falls back to `.clear` and
    /// `isValid` is set to `false`, allowing integrators to handle invalid input
    public struct Color: Sendable {
        public let uiColor: UIColor
        public let isValid: Bool

        /// Creates a configuration color from an existing `UIColor`.
        public init(uiColor: UIColor) {
            self.uiColor = uiColor
            isValid = true
        }

        /// Creates a color from a hex string.
        ///
        /// Supported formats (case-insensitive, optional `#` or `0x` prefix):
        /// - `"#RGB"`, `"RGB"`, `"0xRGB"`                     → expands to `RRGGBB` (alpha = `FF`)
        /// - `"#ARGB"`, `"ARGB"`, `"0xARGB"`                 → expands to `AARRGGBB`
        /// - `"#RRGGBB"`, `"RRGGBB"`, `"0xRRGGBB"`           → RGB (alpha assumed to be `FF`)
        /// - `"#AARRGGBB"`, `"AARRGGBB"`, `"0xAARRGGBB"`     → ARGB
        ///
        /// If parsing fails, the color falls back to `.clear` and `isValid = false`.
        public init(hex: String) {
            var s = hex
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()

            // Remove common prefixes
            if s.hasPrefix("#") {
                s.removeFirst()
            } else if s.hasPrefix("0x") {
                s.removeFirst(2)
            }

            // Validate hex characters
            let hexSet = CharacterSet(charactersIn: "0123456789abcdef")
            guard s.unicodeScalars.allSatisfy({ hexSet.contains($0) }) else {
                uiColor = .clear
                isValid = false
                return
            }

            // Expand shorthand forms
            switch s.count {
                case 3: // RGB → RRGGBB
                    let c = Array(s)
                    s = "\(c[0])\(c[0])\(c[1])\(c[1])\(c[2])\(c[2])"
                case 4: // ARGB → AARRGGBB
                    let c = Array(s)
                    s = "\(c[0])\(c[0])\(c[1])\(c[1])\(c[2])\(c[2])\(c[3])\(c[3])"
                case 6, 8:
                    break
                default:
                    uiColor = .clear
                    isValid = false
                    return
            }

            guard let value = UInt32(s, radix: 16) else {
                uiColor = .clear
                isValid = false
                return
            }

            let a, r, g, b: CGFloat

            if s.count == 8 {
                // AARRGGBB
                a = CGFloat((value >> 24) & 0xFF) / 255.0
                r = CGFloat((value >> 16) & 0xFF) / 255.0
                g = CGFloat((value >> 8) & 0xFF) / 255.0
                b = CGFloat(value & 0xFF) / 255.0
            } else {
                // RRGGBB (alpha assumed to be FF)
                a = 1.0
                r = CGFloat((value >> 16) & 0xFF) / 255.0
                g = CGFloat((value >> 8) & 0xFF) / 255.0
                b = CGFloat(value & 0xFF) / 255.0
            }

            uiColor = UIColor(red: r, green: g, blue: b, alpha: a)
            isValid = true
        }

        /// Creates a color from a hex string only if the value is valid.
        ///
        /// This initializer performs strict validation. If the provided string
        /// cannot be parsed as a supported hex color format, the initializer
        /// returns `nil` instead of falling back to `.clear`.
        ///
        /// - Parameter validHex: A hex color string in one of the formats supported
        ///   by `init(hex:)`.
        public init?(validHex hex: String) {
            self.init(hex: hex)
            guard isValid else { return nil }
        }

        /// Creates a color from an optional hex string.
        ///
        /// This initializer is intended for configuration values coming from
        /// optional sources such as dictionaries, JSON payloads, or user-defined
        /// theme files.
        ///
        /// If the value is `nil` or cannot be parsed, the color falls back to
        /// `.clear` and `isValid` is set to `false`.
        ///
        /// - Parameter optionalHex: An optional hex color string.
        public init(optionalHex hex: String?) {
            self.init(hex: hex ?? "")
        }
        
        /// Creates a color from an ARGB hexadecimal value.
        ///
        /// The value is interpreted as `0xAARRGGBB`, where:
        /// - `AA` is the alpha component
        /// - `RR` is the red component
        /// - `GG` is the green component
        /// - `BB` is the blue component
        ///
        /// The value is converted to a hexadecimal string, left-padded to
        /// 8 hex digits, and parsed using the same rules as `init(hex:)`.
        ///
        /// - Parameter argb: An ARGB color value in the `0xAARRGGBB` format.
        public init<U: UnsignedInteger>(argb value: U) {
            self.init(hex: String(UInt64(value), radix: 16).leftPadded(to: 8))
        }

        /// Creates a color from an RGB hexadecimal value.
        ///
        /// The value is interpreted as `0xRRGGBB`. The alpha component is
        /// assumed to be `FF` (fully opaque).
        ///
        /// The value is converted to a hexadecimal string, left-padded to
        /// 6 hex digits, and parsed using the same rules as `init(hex:)`.
        ///
        /// - Parameter rgb: An RGB color value in the `0xRRGGBB` format.
        public init<U: UnsignedInteger>(rgb value: U) {
            self.init(hex: String(UInt64(value), radix: 16).leftPadded(to: 6))
        }
    }
}

// MARK: - Literal support

extension Aiuta.Configuration.Color: ExpressibleByStringLiteral {
    /// Enables: `let c: Color = "#FF0000"`
    public init(stringLiteral value: String) {
        self.init(hex: value)
    }
}

extension Aiuta.Configuration.Color: ExpressibleByIntegerLiteral {
    /// Enables: `let c: Color = 0x80FF0000`
    ///
    /// - Note: Integer literals are always interpreted as ARGB (`0xAARRGGBB`).
    ///
    /// The provided value is converted to a hexadecimal string, left-padded
    /// to 8 digits, and parsed using the same rules as `init(hex:)`.
    public init(integerLiteral value: UInt64) {
        self.init(hex: String(value, radix: 16).leftPadded(to: 8))
    }
}

private extension String {
    func leftPadded(to width: Int, with pad: Character = "0") -> String {
        if count >= width { return self }
        return String(repeating: String(pad), count: width - count) + self
    }
}
