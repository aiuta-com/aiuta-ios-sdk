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

@_spi(Aiuta) public extension UIColor {
    struct HSLA: Hashable, Comparable {
        public static let maxDeviation: HSLA = .init(h: 360, s: 100, l: 100, a: 560)
        public static let minDeviation: HSLA = .init(h: 0, s: 0, l: 0, a: 0)

        /// The hue component of the color, in the range [0, 360°].
        public var hue: CGFloat
        /// The saturation component of the color, in the range [0, 100%].
        public var saturation: CGFloat
        /// The lightness component of the color, in the range [0, 100%].
        public var lightness: CGFloat
        /// The alpha component of the color, in the range [0, 100%].
        public var alpha: CGFloat

        public init(h: CGFloat, s: CGFloat, l: CGFloat, a: CGFloat) {
            hue = h
            saturation = s
            lightness = l
            alpha = a
        }

        public func prettyString() -> String {
            String(format: "h: %.0f s: %.0f l: %.0f a: %.0f", hue, saturation, lightness, alpha)
        }

        public static func < (lhs: UIColor.HSLA, rhs: UIColor.HSLA) -> Bool {
            lhs.hue < rhs.hue && lhs.saturation < rhs.saturation && lhs.lightness < rhs.lightness && lhs.alpha < rhs.alpha
        }
    }

    var hsla: HSLA {
        var (h, s, b, a) = (CGFloat(), CGFloat(), CGFloat(), CGFloat())
        getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        let l = ((2.0 - s) * b) / 2.0

        switch l {
            case 0.0, 1.0:
                s = 0.0
            case 0.0 ..< 0.5:
                s = (s * b) / (l * 2.0)
            default:
                s = (s * b) / (2.0 - l * 2.0)
        }

        return HSLA(
            h: h * 360.0,
            s: s * 100.0,
            l: l * 100.0,
            a: a * 100.0
        )
    }

    convenience init(hsla: HSLA) {
        let h = hsla.hue / 360.0
        var s = hsla.saturation / 100.0
        let l = hsla.lightness / 100.0
        let a = hsla.alpha / 100.0

        let t = s * ((l < 0.5) ? l : (1.0 - l))
        let b = l + t
        s = (l > 0.0) ? (2.0 * t / b) : 0.0

        self.init(hue: h, saturation: s, brightness: b, alpha: a)
    }

    convenience init(hex: Int64) {
        let red: CGFloat = CGFloat((hex & 0xFF000000) >> 24) / 255
        let green: CGFloat = CGFloat((hex & 0x00FF0000) >> 16) / 255
        let blue: CGFloat = CGFloat((hex & 0x0000FF00) >> 8) / 255
        let alpha: CGFloat = CGFloat(hex & 0x000000FF) / 255

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }

    convenience init?(hexString: String?) {
        guard let hexString else { return nil }
        self.init(hexString: hexString)
    }
}

@_spi(Aiuta) public extension CGColor {
    func prettyString() -> String {
        var result = ""
        guard let components else { return result }
        for c in 0 ..< numberOfComponents {
            if !result.isEmpty { result += ", " }
            result += String(format: "%.1f", components[c])
        }
        return result
    }
}

@_spi(Aiuta) public extension Int {
    var uiColor: UIColor {
        UIColor(hex: Int64(self))
    }

    var cgColor: CGColor {
        uiColor.cgColor
    }
}

@_spi(Aiuta) public extension UIColor {
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return adjust(by: abs(percentage))
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return adjust(by: -1 * abs(percentage))
    }

    private func adjust(by percentage: CGFloat = 30.0) -> UIColor {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return self }
        return UIColor(red: min(red + percentage / 100, 1.0),
                       green: min(green + percentage / 100, 1.0),
                       blue: min(blue + percentage / 100, 1.0),
                       alpha: alpha)
    }
}
