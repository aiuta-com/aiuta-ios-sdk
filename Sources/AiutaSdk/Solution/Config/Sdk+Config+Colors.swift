
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

extension Sdk.Configuration {
    struct Colors {
        var scheme: Aiuta.Configuration.UserInterface.ColorScheme = .light

        // MARK: - General

        var brand: UIColor = 0x4000FFFF.uiColor
        var primary: UIColor = 0x000000FF.uiColor
        var secondary: UIColor = 0x9F9F9FFF.uiColor
        var onDark: UIColor = 0xFFFFFFFF.uiColor
        var onLight: UIColor = 0x000000FF.uiColor
        var background: UIColor = 0xFFFFFFFF.uiColor
        var screen: UIColor = 0x000000FF.uiColor
        var neutral: UIColor = 0xF2F2F7FF.uiColor
        var border: UIColor = 0xE5E5EAFF.uiColor
        var outline: UIColor = 0xC7C7CCFF.uiColor

        // MARK: - Selection

        var selectionBackground: UIColor = 0x000000FF.uiColor

        // MARK: - Error

        var errorBackground: UIColor = 0xEF5754FF.uiColor
        var errorPrimary: UIColor = 0xFFFFFFFF.uiColor

        // MARK: - ProductBar.Price

        var discountedPrice: UIColor = 0xFB1010FF.uiColor

        // MARK: - PowerBar

        var aiuta: UIColor = 0x4000FFFF.uiColor

        // MARK: - Activity

        var activityOverlay: UIColor = 0x00000099.uiColor

        // MARK: - TryOn

        var tryOnButtonGradient: [UIColor]?

        // MARK: - TryOn.Loading

        var tryOnBackgroundGradient: [UIColor] = [0x4000FFFF.uiColor,
                                                  0x4000FF80.uiColor,
                                                  0x4000FF00.uiColor]
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
