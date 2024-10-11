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

struct SdkThemeColors: DesignSystemColors {
    var ground: UIColor { appearance.colors.background ?? appearance.backgroundTint ?? .white }
    var popup: UIColor { ground }
    var item: UIColor { ground }
    var accent: UIColor { appearance.colors.accent ?? appearance.accentColor ?? 0xFB1010FF.uiColor }
    var tint: UIColor { primary }
    var highlight: UIColor { accent }
    var error: UIColor { appearance.colors.error ?? 0xEF5754FF.uiColor }
}

extension DesignSystemColors {
    var primary: UIColor { appearance.colors.primary ?? 0x000000FF.uiColor }
    var secondary: UIColor { appearance.colors.secondary ?? 0x9F9F9FFF.uiColor }
    var tertiary: UIColor { appearance.colors.tertiary ?? 0xEEEEEEFF.uiColor }
    var onDark: UIColor { appearance.colors.onDark ?? 0xFFFFFFFF.uiColor }
    var onError: UIColor { appearance.colors.onError ?? 0xFFFFFFFF.uiColor }
}

extension DesignSystemColors {
    var brand: UIColor { appearance.colors.brand ?? appearance.brandColor ?? 0x4000FFFF.uiColor }
    var neutral: UIColor { appearance.colors.neutral ?? 0xF2F2F7FF.uiColor }
    var neutral2: UIColor { appearance.colors.neutral2 ?? 0xE5E5EAFF.uiColor }
    var neutral3: UIColor { appearance.colors.neutral3 ?? 0xC7C7CCFF.uiColor }
}

extension DesignSystemColors {
    var green: UIColor { appearance.colors.green ?? 0x00C35AFF.uiColor }
    var red: UIColor { appearance.colors.red ?? 0xEF5754FF.uiColor }
}

extension DesignSystemColors {
    var gray: UIColor { appearance.colors.gray ?? 0xB2B2B2FF.uiColor }
    var lightGray: UIColor { appearance.colors.lightGray ?? 0xEEEEEEFF.uiColor }
    var darkGray: UIColor { appearance.colors.darkGray ?? 0xCCCCCCFF.uiColor }
}

extension DesignSystemColors {
    private var loadingAnimationDefaults: [UIColor] {
        [0x4000FFFF.uiColor, 0x4000FF80.uiColor, 0x4000FF00.uiColor]
    }

    var loadingAnimation: [UIColor] {
        if appearance.colors.loadingAnimation.isSomeAndNotEmpty {
            return appearance.colors.loadingAnimation ?? loadingAnimationDefaults
        } else {
            return loadingAnimationDefaults
        }
    }
}
