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

extension AiutaSdkDesignSystem: DesignSystemFonts {
    var `default`: FontRef {
        SFPro(size: 14, kern: -0.4, color: UIColor(hex: 0xADADADFF))
    }
}

extension DesignSystemFonts {
    var poweredBy: FontRef { SFPro(style: .medium, size: 13, kern: -0.13, lineHeightMultiple: 1.06, color: 0x4000FFFF.uiColor) }

    var button: FontRef { SFPro(style: .bold, size: 14, kern: -0.28, lineHeightMultiple: 1.1, color: .white) }
    var buttonBig: FontRef { SFPro(style: .medium, size: 17, kern: -0.17, lineHeightMultiple: 1.1, color: .white) }
    var secondary: FontRef { SFPro(style: .medium, size: 13, kern: -0.26, color: 0x484848FF.uiColor) }

    var menu: FontRef { SFPro(style: .medium, size: 17, kern: -0.89, lineHeightMultiple: 1.1, color: .black) }
    var header: FontRef { SFPro(style: .bold, size: 26, kern: -0.52, color: .black) }
    var footer: FontRef { SFPro(style: .medium, size: 14, kern: -0.49, lineHeightMultiple: 1.06, color: .white) }
    var navBar: FontRef { SFPro(style: .medium, size: 18, kern: -0.4, lineHeightMultiple: 1.08, color: .black) }
    var navAction: FontRef { SFPro(style: .medium, size: 17, kern: -0.4, lineHeightMultiple: 1.08, color: .black) }

    var historyBulletinTitle: FontRef { SFPro(style: .medium, size: 20, kern: -0.4, color: .black) }
    var historyPlaceholder: FontRef { SFPro(style: .regular, size: 15, kern: -0.15, lineHeightMultiple: 1.01, color: .black) }

    var skuCellTitle: FontRef { SFPro(size: 12, kern: -0.12, color: .black) }
    var skuCellStore: FontRef { SFPro(style: .medium, size: 12, kern: -0.12, color: 0x9F9F9FFF.uiColor) }
    var skuCellPrice: FontRef { SFPro(style: .bold, size: 14, kern: -0.14, color: .black) }

    var skuBulletinTitle: FontRef { SFPro(size: 14, color: .black) }
    var skuBulletinStore: FontRef { SFPro(style: .medium, size: 14, color: 0xB2B2B2FF.uiColor) }
    var skuBulletinPrice: FontRef { SFPro(style: .bold, size: 16, color: .black) }

    var skuBarPrice: FontRef { SFPro(style: .bold, size: 14, color: .black) }
    var skuBarOldPrice: FontRef { SFPro(style: .bold, size: 13, color: 0xB2B2B2FF.uiColor, strikethrough: .single) }
    var skuBarNewPrice: FontRef { SFPro(style: .bold, size: 16, color: 0xFB0000FF.uiColor) }
    var skuBarDiscount: FontRef { SFPro(style: .bold, size: 12, lineHeightMultiple: 1.1, color: .white) }

    var boardingHeader: FontRef { SFPro(style: .bold, size: 24, color: .black) }
    var boardingText: FontRef { SFPro(style: .medium, size: 17, kern: -0.51, lineHeightMultiple: 1.08, color: 0x484848FF.uiColor) }

    var disclaimerTitle: FontRef { SFPro(style: .regular, size: 12, kern: -0.12, color: .black) }
    var disclaimerText: FontRef { SFPro(style: .medium, size: 17, kern: -0.51, lineHeightMultiple: 1.08, color: .black) }

    var snackbar: FontRef { SFPro(style: .medium, size: 14, kern: -0.35, lineHeightMultiple: 1.08, color: .white) }
}

struct SFPro: FontRef {
    var family: String { "SFPro" }
    var style: FontStyle = .regular
    var size: CGFloat = 14
    var kern: CGFloat = 0
    var baselineOffset: CGFloat = 0
    var lineHeightMultiple: CGFloat = 0
    var color: UIColor = .black
    var underline: NSUnderlineStyle? = nil
    var strikethrough: NSUnderlineStyle? = nil

    func changing(size newSize: CGFloat) -> SFPro {
        SFPro(style: style, size: newSize, kern: kern, baselineOffset: baselineOffset, lineHeightMultiple: lineHeightMultiple, color: color)
    }

    func changing(color newColor: UIColor) -> SFPro {
        SFPro(style: style, size: size, kern: kern, baselineOffset: baselineOffset, lineHeightMultiple: lineHeightMultiple, color: newColor)
    }

    func changing(color hexColor: Int64) -> SFPro {
        changing(color: UIColor(hex: hexColor))
    }

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
            case .blackOblique: return .black
        }
    }
}
