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

extension Sdk {
    struct Theme: DesignSystem {
        let kit: DesignSystemKit

        init(_ configuration: Aiuta.Configuration) {
            kit = Kit(configuration: configuration)
        }
    }
}

extension DesignSystem {
    var styles: Sdk.Theme.Styles { .init(config: kit.themeConfiguration) }
    var colors: Sdk.Theme.Colors { .init(config: kit.themeConfiguration) }
    var fonts: Sdk.Theme.Fonts { .init(config: kit.themeConfiguration) }
    var shapes: Sdk.Theme.Shapes { .init(config: kit.themeConfiguration) }
    var icons: Sdk.Theme.Icons { .init(config: kit.themeConfiguration) }
    var images: Sdk.Theme.Images { .init(config: kit.themeConfiguration) }
    var strings: Sdk.Theme.Strings { .init(config: kit.themeConfiguration) }
    var features: Sdk.Theme.Features { .init(config: kit.themeConfiguration) }
}

extension DesignSystemKit {
    var themeConfiguration: Aiuta.Configuration { (self as! Sdk.Theme.Kit).configuration }
}

extension Sdk.Theme {
    struct Kit: DesignSystemKit {
        let configuration: Aiuta.Configuration

        var style: UIUserInterfaceStyle { configuration.userInterface.theme.color.scheme.userInterfaceStyle }
        var ground: UIColor { configuration.userInterface.theme.color.background }
        var popup: UIColor { configuration.userInterface.theme.color.background }
        var item: UIColor { configuration.userInterface.theme.color.background }
        var accent: UIColor { configuration.userInterface.theme.color.brand }
        var tint: UIColor { configuration.userInterface.theme.color.primary }
        var highlight: UIColor { configuration.userInterface.theme.color.brand }
        var error: UIColor { configuration.userInterface.theme.errorSnackbar.colors.errorBackground }
        var font: FontRef { Sdk.Theme.Font(configuration.userInterface.theme.label.typography.regular) }
    }
}
