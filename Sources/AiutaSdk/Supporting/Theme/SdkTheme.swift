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

struct SdkTheme: DesignSystem, DesignSystemTransitions, DesignSystemStyles {
    fileprivate static var config: Aiuta.Configuration = .default

    let image: DesignSystemImages
    let font: DesignSystemFonts
    let color: DesignSystemColors
    let dimensions: DesignSystemDimensions

    var style: DesignSystemStyles { self }
    var transition: DesignSystemTransitions { self }

    init(_ configuration: Aiuta.Configuration) {
        SdkTheme.config = configuration
        color = SdkThemeColors()
        dimensions = SdkThemeDimensions()
        font = SdkThemeFonts()
        image = SdkThemeImages()
    }
}

extension DesignSystem {
    var config: Aiuta.Configuration {
        SdkTheme.config
    }
}

extension DesignSystemColors {
    var config: Aiuta.Configuration.Appearance.Colors {
        SdkTheme.config.appearance.colors
    }
}

extension DesignSystemDimensions {
    var config: Aiuta.Configuration.Appearance.Dimensions {
        SdkTheme.config.appearance.dimensions
    }
}

extension DesignSystemFonts {
    var config: Aiuta.Configuration.Appearance.Fonts {
        SdkTheme.config.appearance.fonts
    }
}

extension DesignSystemImages {
    var config: Aiuta.Configuration.Appearance.Images {
        SdkTheme.config.appearance.images
    }
}
