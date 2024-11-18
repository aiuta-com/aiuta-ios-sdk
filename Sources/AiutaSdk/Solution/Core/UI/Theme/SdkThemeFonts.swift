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

@_spi(Aiuta) import AiutaKit
import UIKit

struct SdkThemeFonts: DesignSystemFonts {
    var `default`: FontRef { regular }
}

extension DesignSystemFonts {
    var titleXL: FontRef { config.titleXL?.ref ?? SdkFont(style: .heavy, size: 40, lineHeightMultiple: 0.92) }
    var welcome: FontRef { config.welcome?.ref ?? SdkFont(style: .medium, size: 16, lineHeightMultiple: 1.18) }

    var titleL: FontRef { config.titleL?.ref ?? SdkFont(style: .bold, size: 24) }
    var titleM: FontRef { config.titleM?.ref ?? SdkFont(style: .bold, size: 20, kern: -0.4) }

    var navBar: FontRef { config.navBar?.ref ?? SdkFont(style: .medium, size: 17, kern: -0.51, lineHeightMultiple: 1.08) }
    var regular: FontRef { config.regular?.ref ?? SdkFont(style: .medium, size: 17, kern: -0.51, lineHeightMultiple: 1.08) }
    var button: FontRef { config.button?.ref ?? SdkFont(style: .semibold, size: 17, kern: -0.17, lineHeightMultiple: 0.89) }
    var buttonS: FontRef { config.buttonS?.ref ?? SdkFont(style: .semibold, size: 13, kern: -0.13, lineHeightMultiple: 1.16) }

    var cells: FontRef { config.cells?.ref ?? SdkFont(style: .medium, size: 17, kern: -0.17) }
    var chips: FontRef { config.chips?.ref ?? SdkFont(style: .regular, size: 15, kern: -0.15, lineHeightMultiple: 1.01) }

    var product: FontRef { config.product?.ref ?? SdkFont(style: .regular, size: 13) }
    var price: FontRef { config.price?.ref ?? SdkFont(style: .bold, size: 14, kern: -0.14) }
    var brand: FontRef { config.brand?.ref ?? SdkFont(style: .medium, size: 12, kern: -0.12) }

    var description: FontRef { config.description?.ref ?? SdkFont(style: .regular, size: 12, kern: -0.12) }
}

// MARK: - Default

struct SdkFont: FontRef {
    var family: String { "-apple-system" }
    var style: FontStyle = .regular
    var size: CGFloat = 14
    var kern: CGFloat = 0
    var baselineOffset: CGFloat = 0
    var lineHeightMultiple: CGFloat = 0
    var color: UIColor = .black
    var underline: NSUnderlineStyle? = nil
    var strikethrough: NSUnderlineStyle? = nil

    func uiFont() -> UIFont? {
        UIFont.systemFont(ofSize: size, weight: style.weight)
    }
}

extension FontStyle {
    var weight: UIFont.Weight {
        switch self {
            case .medium: return .medium
            case .regular: return .regular
            case .light: return .light
            case .semibold: return .semibold
            case .bold: return .bold
            case .heavy: return .heavy
            case .blackOblique: return .black
        }
    }
}

extension UIFont.Weight {
    var style: FontStyle {
        switch self {
            case .medium: return .medium
            case .regular: return .regular
            case .light: return .light
            case .semibold: return .semibold
            case .bold: return .bold
            case .heavy: return .heavy
            case .black: return .blackOblique
            default: return .regular
        }
    }
}

// MARK: - Custom

struct CustomFontWrapper: FontRef {
    var family: String { font.family }
    var style: FontStyle { font.weight.style }
    var size: CGFloat { font.size }
    var kern: CGFloat { font.kern ?? 0 }
    var baselineOffset: CGFloat = 0
    var lineHeightMultiple: CGFloat { font.lineHeightMultiple ?? 1 }
    var color: UIColor = .black
    var underline: NSUnderlineStyle?
    var strikethrough: NSUnderlineStyle?

    private let font: Aiuta.Configuration.Appearance.CustomFont

    init(font: Aiuta.Configuration.Appearance.CustomFont) {
        self.font = font
    }

    func uiFont() -> UIFont? { font.font.withSize(size) }
}

private extension Aiuta.Configuration.Appearance.CustomFont {
    var ref: FontRef { CustomFontWrapper(font: self) }
}
