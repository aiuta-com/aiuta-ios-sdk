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

import AiutaConfig
import AiutaCore
@_spi(Aiuta) import AiutaKit
import UIKit

extension Sdk.Theme {
    struct Fonts {
        let config: Aiuta.Configuration
        private var theme: Aiuta.Configuration.UserInterface.Theme { config.userInterface.theme }

        // MARK: - Label

        var titleL: Sdk.Theme.Font { Font(theme.label.typography.titleL) }
        var titleM: Sdk.Theme.Font { Font(theme.label.typography.titleM) }
        var regular: Sdk.Theme.Font { Font(theme.label.typography.regular) }
        var subtle: Sdk.Theme.Font { Font(theme.label.typography.subtle) }

        // MARK: - Button

        var buttonM: Sdk.Theme.Font { Font(theme.button.typography.buttonM) }
        var buttonS: Sdk.Theme.Font { Font(theme.button.typography.buttonS) }

        // MARK: - PageBar

        var pageTitle: Sdk.Theme.Font { Font(theme.pageBar.typography.pageTitle) }

        // MARK: - BottomSheet

        var iconButton: Sdk.Theme.Font { Font(theme.bottomSheet.typography.iconButton) }

        // MARK: - ProductBar

        var product: Sdk.Theme.Font { Font(theme.productBar.typography.product) }
        var brand: Sdk.Theme.Font { Font(theme.productBar.typography.brand) }
        var price: Sdk.Theme.Font {
            if let prices = theme.productBar.prices {
                return Font(prices.typography.price)
            }
            return .system(size: 14, weight: .bold, kern: -0.14)
        }

        // MARK: - Welcome Screen

        var welcomeTitle: Sdk.Theme.Font {
            if let ws = config.features.welcomeScreen {
                return Font(ws.typography.welcomeTitle)
            }
            return .system(size: 40, weight: .heavy, lhm: 0.92)
        }

        var welcomeDescription: Sdk.Theme.Font {
            if let ws = config.features.welcomeScreen {
                return Font(ws.typography.welcomeDescription)
            }
            return .system(size: 16, weight: .medium, lhm: 1.18)
        }

        // MARK: - TryOn.FitDisclaimer

        var disclaimer: Sdk.Theme.Font {
            if let fd = config.features.tryOn.fitDisclaimer {
                return Font(fd.typography.disclaimer)
            }
            return .system(size: 12, weight: .regular, kern: -0.12)
        }

        // MARK: - TryOn.Feedback

        var gratitudeEmoji: Sdk.Theme.Font { .system(size: 40, weight: .medium) }

        // MARK: - SizeFit

        var sizeRecommendation: Sdk.Theme.Font { .system(size: 132, weight: .medium, kern: -3.94) }
    }
}

// MARK: - Kit FontRef implementation

extension Sdk.Theme {
    struct Font: FontRef {
        let font: UIFont
        let family: String
        let style: FontStyle
        let size: CGFloat
        let kern: CGFloat
        let lineHeightMultiple: CGFloat
        let baselineOffset: CGFloat = 0
        let color: UIColor = .black
        let underline: NSUnderlineStyle? = nil
        let strikethrough: NSUnderlineStyle? = nil

        static func system(size: CGFloat,
                           weight: UIFont.Weight,
                           kern: CGFloat? = nil,
                           lhm: CGFloat? = nil) -> Sdk.Theme.Font {
            .init(.init(size: size, weight: weight, kern: kern, lineHeightMultiple: lhm))
        }

        init(_ textStyle: Aiuta.TextStyle) {
            font = textStyle.font
            if font.isSystemFont {
                family = "-apple-system"
            } else if textStyle.font.fontName.hasSuffix("-" + textStyle.weight.nameSuffix) {
                family = String(textStyle.font.fontName.dropLast(textStyle.weight.nameSuffix.count + 1))
            } else {
                family = textStyle.font.fontName.split(separator: "-").dropLast().joined(separator: "-")
            }
            style = textStyle.weight.fontStyle
            size = textStyle.size
            kern = textStyle.kern ?? 0
            lineHeightMultiple = textStyle.lineHeightMultiple ?? 1
        }

        func uiFont() -> UIFont? { font.withSize(size) }
    }
}

extension UIFont.Weight {
    var nameSuffix: String {
        switch self {
            case .ultraLight: return "UltraLight"
            case .thin: return "Thin"
            case .light: return "Light"
            case .regular: return "Regular"
            case .medium: return "Medium"
            case .semibold: return "Semibold"
            case .bold: return "Bold"
            case .heavy: return "Heavy"
            case .black: return "Black"
            default: return "Regular"
        }
    }

    var fontStyle: FontStyle {
        switch self {
            case .ultraLight: return .light
            case .thin: return .light
            case .light: return .light
            case .regular: return .regular
            case .medium: return .medium
            case .semibold: return .semibold
            case .bold: return .bold
            case .heavy: return .heavy
            case .black: return .blackOblique
            default: return .regular
        }
    }
}

extension UIFont {
    var isSystemFont: Bool {
        let weights: [UIFont.Weight] = [
            .ultraLight, .thin, .light, .regular,
            .medium, .semibold, .bold, .heavy, .black,
        ]

        return weights.contains(where: {
            UIFont.systemFont(ofSize: pointSize, weight: $0).fontName == fontName
        })
    }
}
