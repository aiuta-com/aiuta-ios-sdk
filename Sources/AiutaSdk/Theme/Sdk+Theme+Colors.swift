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

#if SWIFT_PACKAGE
import AiutaConfig
import AiutaCore
@_spi(Aiuta) import AiutaKit
#endif
import UIKit

extension Sdk.Theme {
    struct Colors {
        let config: Aiuta.Configuration
        private var color: Aiuta.Configuration.UserInterface.ColorTheme { config.userInterface.theme.color }
        private var theme: Aiuta.Configuration.UserInterface.Theme { config.userInterface.theme }

        // MARK: - General

        var scheme: Aiuta.Configuration.UserInterface.ColorScheme { color.scheme }
        var brand: UIColor { color.brand.uiColor }
        var primary: UIColor { color.primary.uiColor }
        var secondary: UIColor { color.secondary.uiColor }
        var onDark: UIColor { color.onDark.uiColor }
        var onLight: UIColor { color.onLight.uiColor }
        var background: UIColor { color.background.uiColor }
        var screen: UIColor { color.screen?.uiColor ?? UIColor.black }
        var neutral: UIColor { color.neutral.uiColor }
        var border: UIColor { color.border.uiColor }
        var link: UIColor { 0x4000FFFF.uiColor }

        // MARK: - Selection

        var selectionBackground: UIColor { theme.selectionSnackbar.colors.selectionBackground.uiColor }

        // MARK: - Error

        var errorBackground: UIColor { theme.errorSnackbar.colors.errorBackground.uiColor }
        var errorPrimary: UIColor { theme.errorSnackbar.colors.errorPrimary.uiColor }

        // MARK: - ProductBar.Price

        var discountedPrice: UIColor { theme.productBar.prices?.colors.discountedPrice.uiColor ?? 0xFB1010FF.uiColor }

        // MARK: - PowerBar

        var aiuta: UIColor {
            switch theme.powerBar.colors.aiuta {
                case .default: return UIColor.black
                case .primary: return color.primary.uiColor
            }
        }

        // MARK: - Activity

        var activityOverlay: UIColor { theme.activityIndicator.colors.overlay.uiColor }

        // MARK: - TryOn

        var tryOnButtonGradient: [UIColor] { config.features.tryOn.styles.tryOnButtonGradient.map(\.uiColor) }

        // MARK: - TryOn.Loading

        var tryOnBackgroundGradient: [UIColor] { config.features.tryOn.loadingPage.styles.backgroundGradient.map(\.uiColor) }
    }
}

// MARK: - UIUserInterfaceStyle

extension Aiuta.Configuration.UserInterface.ColorScheme {
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
            case .light: return .light
            case .dark: return .dark
        }
    }

    var blurStyle: UIBlurEffect.Style {
        switch self {
            case .light: return .extraLight
            case .dark: return .dark
        }
    }

    var safeBlurStyle: UIBlurEffect.Style {
        switch self {
            case .light: return .light
            case .dark: return .dark
        }
    }
}
