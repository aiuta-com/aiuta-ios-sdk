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
    case medium
    case regular
    case light
    case bold
    case semibold
    case blackOblique

    fileprivate var descriptor: String {
        rawValue.firstCapitalized
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

    func changing(size: CGFloat) -> Self
    func changing(color: UIColor) -> Self
    func changing(color: Int64) -> Self
    
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
