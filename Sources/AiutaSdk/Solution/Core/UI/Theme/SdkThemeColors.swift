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
    var style: UIUserInterfaceStyle { config.style.userInterface }
    var ground: UIColor { config.background ?? .white }
    var popup: UIColor { ground }
    var item: UIColor { ground }
    var accent: UIColor { brand }
    var tint: UIColor { primary }
    var highlight: UIColor { accent }
    var error: UIColor { config.error ?? 0xEF5754FF.uiColor }
}

extension DesignSystemColors {
    var primary: UIColor { config.primary ?? 0x000000FF.uiColor }
    var secondary: UIColor { config.secondary ?? 0x9F9F9FFF.uiColor }
    var tertiary: UIColor { config.tertiary ?? 0xEEEEEEFF.uiColor }
    var onDark: UIColor { config.onDark ?? 0xFFFFFFFF.uiColor }
    var onError: UIColor { config.onError ?? 0xFFFFFFFF.uiColor }
}

extension DesignSystemColors {
    var brand: UIColor { config.brand ?? 0x4000FFFF.uiColor }
    var aiuta: UIColor { config.aiuta ?? 0x4000FFFF.uiColor }
    var neutral: UIColor { config.neutral ?? 0xF2F2F7FF.uiColor }
    var neutral2: UIColor { config.neutral2 ?? 0xE5E5EAFF.uiColor }
    var neutral3: UIColor { config.neutral3 ?? 0xC7C7CCFF.uiColor }
}

extension DesignSystemColors {
    private var loadingAnimationDefaults: [UIColor] {
        [0x4000FFFF.uiColor, 0x4000FF80.uiColor, 0x4000FF00.uiColor]
    }

    var loadingAnimation: [UIColor] {
        if config.tryOnAnimationGradient.isSomeAndNotEmpty {
            return config.tryOnAnimationGradient ?? loadingAnimationDefaults
        } else {
            return loadingAnimationDefaults
        }
    }

    var tryOnButtonGradient: [UIColor]? {
        config.tryOnButtonGradient
    }
}

extension DesignSystemColors {
    var blur: UIBlurEffect.Style {
        switch config.style {
            case .light: return .extraLight
            case .dark: return .dark
        }
    }
}
