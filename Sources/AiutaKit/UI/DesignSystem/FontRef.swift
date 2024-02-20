//
// Created by nGrey on 04.02.2023.
//

import UIKit

public enum FontStyle: String {
    case medium
    case regular
    case light
    case bold
    case blackOblique

    fileprivate var descriptor: String {
        rawValue.firstCapitalized
    }
}

public protocol FontRef {
    var family: String { get }
    var style: FontStyle { get }
    var size: CGFloat { get }
    var kern: CGFloat { get }
    var baselineOffset: CGFloat { get }
    var lineHeightMultiple: CGFloat { get }
    var color: UIColor { get }
    var underline: NSUnderlineStyle? { get }
    var strikethrough: NSUnderlineStyle? { get }

    func changing(size: CGFloat) -> Self
    func changing(color: UIColor) -> Self
    func changing(color: Int64) -> Self
    
    func uiFont() -> UIFont?
}

public extension FontRef {
    func uiFont() -> UIFont? {
        UIFont(name: "\(family)-\(style.descriptor)", size: size)
    }

    func uiFontDescriptor() -> UIFontDescriptor {
        UIFontDescriptor(name: "\(family)-\(style.descriptor)", size: size)
    }
}
