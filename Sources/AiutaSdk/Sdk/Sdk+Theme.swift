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

extension Sdk {
    struct Theme: DesignSystem {
        let kit: DesignSystemKit

        init(_ config: Sdk.Configuration) {
            kit = Kit(config)
        }
    }
}

extension DesignSystem {
    var styles: Sdk.Configuration.Styles { kit.config.styles }
    var colors: Sdk.Configuration.Colors { kit.config.colors }
    var fonts: Sdk.Configuration.Fonts { kit.config.fonts }
    var shapes: Sdk.Configuration.Shapes { kit.config.shapes }
    var icons: Sdk.Configuration.Icons { kit.config.icons }
    var images: Sdk.Configuration.Images { kit.config.images }
    var strings: Sdk.Configuration.Strings { kit.config.strings }
    var features: Sdk.Configuration.Features { kit.config.features }
}

extension DesignSystemKit {
    var config: Sdk.Configuration {
        (self as? Sdk.Theme.Kit)?._config ?? .init()
    }
}

extension Sdk.Theme {
    struct Kit: DesignSystemKit {
        fileprivate let _config: Sdk.Configuration

        let style: UIUserInterfaceStyle
        let ground: UIColor
        let popup: UIColor
        let item: UIColor
        let accent: UIColor
        let tint: UIColor
        let highlight: UIColor
        let error: UIColor
        let font: FontRef

        init(_ config: Sdk.Configuration) {
            _config = config

            style = config.colors.scheme.userInterfaceStyle
            ground = config.colors.background
            popup = config.colors.background
            item = config.colors.background
            accent = config.colors.brand
            tint = config.colors.primary
            highlight = config.colors.brand
            error = config.colors.errorBackground
            font = config.fonts.regular
        }
    }
}
