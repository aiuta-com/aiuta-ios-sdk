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

@_spi(Aiuta) public enum FontStyle: String {
    case ultraLight
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case blackOblique

    public var descriptor: String {
        rawValue.firstCapitalized
    }

    public var weight: UIFont.Weight {
        switch self {
            case .ultraLight: return .ultraLight
            case .thin: return .thin
            case .light: return .light
            case .regular: return .regular
            case .medium: return .medium
            case .semibold: return .semibold
            case .bold: return .bold
            case .heavy: return .heavy
            case .blackOblique: return .black
        }
    }

    public var numeric: Int {
        switch self {
            case .thin: return 100
            case .ultraLight: return 200
            case .light: return 300
            case .regular: return 400
            case .medium: return 500
            case .semibold: return 600
            case .bold: return 700
            case .heavy: return 900
            case .blackOblique: return 950
        }
    }
}

@_spi(Aiuta) public protocol FontRef {
    var family: String { get }
    var style: FontStyle { get }
    var size: CGFloat { get }
    var kern: CGFloat { get }
    var baselineOffset: CGFloat { get }
    var lineHeightMultiple: CGFloat { get }
    var color: UIColor { get }
    var underline: NSUnderlineStyle? { get }
    var strikethrough: NSUnderlineStyle? { get }

    func uiFont() -> UIFont?
}

@_spi(Aiuta) public extension FontRef {
    func uiFont() -> UIFont? {
        UIFont(name: "\(family)-\(style.descriptor)", size: size)
    }

    func uiFontDescriptor() -> UIFontDescriptor {
        UIFontDescriptor(name: "\(family)-\(style.descriptor)", size: size)
    }
}

@_spi(Aiuta) public extension FontRef {
    func attributes(withAlignment textAlignment: NSTextAlignment,
                    lineBreakMode: NSLineBreakMode? = nil,
                    lineHeightSupport: Bool) -> [NSAttributedString.Key: Any] {
        var viewAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.kern: kern,
        ]

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment
        if lineHeightSupport {
            paragraphStyle.lineHeightMultiple = lineHeightMultiple
        }
        if let lineBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        }
        viewAttributes[.paragraphStyle] = paragraphStyle
        viewAttributes[.baselineOffset] = baselineOffset
        if let underline {
            viewAttributes[.underlineStyle] = underline.rawValue
        }
        if let strikethrough {
            viewAttributes[.strikethroughStyle] = strikethrough.rawValue
        }
        return viewAttributes
    }
}
