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
    struct Colors {
        let config: Aiuta.Configuration
        private var color: Aiuta.Configuration.UserInterface.ColorTheme { config.userInterface.theme.color }
        private var theme: Aiuta.Configuration.UserInterface.Theme { config.userInterface.theme }

        // MARK: - General

        var scheme: Aiuta.Configuration.UserInterface.ColorScheme { color.scheme }
        var brand: UIColor { color.brand }
        var primary: UIColor { color.primary }
        var secondary: UIColor { color.secondary }
        var onDark: UIColor { color.onDark }
        var onLight: UIColor { color.onLight }
        var background: UIColor { color.background }
        var screen: UIColor { color.screen ?? 0x000000FF.uiColor }
        var neutral: UIColor { color.neutral }
        var border: UIColor { color.border }
        var link: UIColor { 0x4000FFFF.uiColor }

        // MARK: - Selection

        var selectionBackground: UIColor { theme.selectionSnackbar.colors.selectionBackground }

        // MARK: - Error

        var errorBackground: UIColor { theme.errorSnackbar.colors.errorBackground }
        var errorPrimary: UIColor { theme.errorSnackbar.colors.errorPrimary }

        // MARK: - ProductBar.Price

        var discountedPrice: UIColor { theme.productBar.prices?.colors.discountedPrice ?? 0xFB1010FF.uiColor }

        // MARK: - PowerBar

        var aiuta: UIColor {
            switch theme.powerBar.colors.aiuta {
                case .default: return 0x000000FF.uiColor
                case .primary: return color.primary
            }
        }

        // MARK: - Activity

        var activityOverlay: UIColor { theme.activityIndicator.colors.overlay }

        // MARK: - TryOn

        var tryOnButtonGradient: [UIColor] { config.features.tryOn.styles.tryOnButtonGradient }

        // MARK: - TryOn.Loading

        var tryOnBackgroundGradient: [UIColor] { config.features.tryOn.loadingPage.styles.backgroundGradient }
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
