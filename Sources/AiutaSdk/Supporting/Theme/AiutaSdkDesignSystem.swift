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

struct AiutaSdkDesignSystem: DesignSystem, DesignSystemImages, DesignSystemTransitions, DesignSystemStyles, DesignSystemDimensions {
    fileprivate static var config: Aiuta.Configuration = .default

    var image: DesignSystemImages { self }
    var style: DesignSystemStyles { self }
    var font: DesignSystemFonts { self }
    var color: DesignSystemColors { self }
    var dimensions: DesignSystemDimensions { self }
    var transition: DesignSystemTransitions { self }

    init(_ configuration: Aiuta.Configuration) {
        AiutaSdkDesignSystem.config = configuration
    }
}

extension DesignSystem {
    var config: Aiuta.Configuration {
        AiutaSdkDesignSystem.config
    }
}

extension AiutaSdkDesignSystem: DesignSystemColors {
    var ground: UIColor { config.appearance.backgroundTint ?? .white }
    var popup: UIColor { 0xEEEEEEFF.uiColor }
    var item: UIColor { .white }
    var accent: UIColor { config.appearance.brandColor ?? 0x4000FFFF.uiColor }
    var tint: UIColor { .black }
    var highlight: UIColor { config.appearance.accentColor ?? .red }
    var error: UIColor { 0xEF5754FF.uiColor }
}

extension DesignSystemColors {
    var gray: UIColor { 0xB2B2B2FF.uiColor }
    var lightGray: UIColor { 0xEEEEEEFF.uiColor }
    var red: UIColor { 0xFB0000FF.uiColor }
}
