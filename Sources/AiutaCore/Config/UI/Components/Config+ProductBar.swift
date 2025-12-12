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

import UIKit

extension Aiuta.Configuration.UserInterface {
    /// Configures the theme for the product bar.
    ///
    /// This setting determines how the product bar looks and behaves. You can use
    /// the default theme or define a custom one to better align with your app's
    /// design and functionality.
    public enum ProductBarTheme {
        /// Use the default product bar theme provided by the SDK.
        case `default`

        /// Define a custom product bar theme.
        ///
        /// - Parameters:
        ///   - icons: Configures the icons for the product bar.
        ///   - typography: Configures the typography for product bar text.
        ///   - settings: Configures the behavior of the product bar.
        ///   - prices: Configures the price display in the product bar.
        case custom(icons: Icons = .builtIn,
                    typography: Typography = .default,
                    settings: Settings = .default,
                    prices: Prices = .default)
    }
}

// MARK: - Icons

extension Aiuta.Configuration.UserInterface.ProductBarTheme {
    /// Configures the icons for the product bar.
    ///
    /// This setting allows you to use the default icons or define custom ones
    /// to better align with your application's visual identity.
    public enum Icons {
        /// Use the default icons built into the SDK.
        case builtIn

        /// Define custom icons for image placeholders.
        ///
        /// - Parameters:
        ///   - arrow16: The icon to display on compact product bar to open details.
        case custom(arrow16: UIImage)

        /// Use a custom icons provider.
        ///
        /// - Parameters:
        ///   - Provider: A provider that supplies the custom icons.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.ProductBarTheme.Icons {
    /// A protocol for providing custom icons for the product bar.
    ///
    /// This protocol defines the required icons for image placeholders.
    /// - Note: This protocol is intended for internal use.
    ///         Use one of `Aiuta.Configuration.Icons` typealias instead.
    public protocol Provider {
        /// The icon to display on compact product bar to open details.
        var arrow16: UIImage { get }
    }
}

// MARK: - Typography

extension Aiuta.Configuration.UserInterface.ProductBarTheme {
    /// Configures the typography for product bar text.
    ///
    /// Typography defines the text styles applied to elements like product names
    /// and brand names. You can use the default typography or define custom styles
    /// to match your app's design language.
    public enum Typography {
        /// Use the default typography provided by the SDK.
        case `default`

        /// Define custom typography for product bar text.
        ///
        /// - Parameters:
        ///   - product: The text style for product names.
        ///   - brand: The text style for brand names.
        case custom(product: Aiuta.Configuration.TextStyle,
                    brand: Aiuta.Configuration.TextStyle)

        /// Use a custom typography provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom typography.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.ProductBarTheme.Typography {
    /// Supplies custom typography for the product bar theme.
    ///
    /// This protocol defines the required text styles for product and brand names.
    /// - Note: Use the `Aiuta.Configuration.Typography` typealias for convenience.
    public protocol Provider {
        /// The text style for product names.
        var product: Aiuta.Configuration.TextStyle { get }

        /// The text style for brand names.
        var brand: Aiuta.Configuration.TextStyle { get }
    }
}

// MARK: - Settings

extension Aiuta.Configuration.UserInterface.ProductBarTheme {
    /// Configures the behavior of the product bar.
    ///
    /// Settings allow you to adjust specific aspects of the product bar, such as
    /// padding for the first product image.
    public enum Settings {
        /// Use the default settings provided by the SDK.
        case `default`

        /// Define custom settings for the product bar.
        ///
        /// - Parameters:
        ///   - applyProductFirstImageExtraPadding: Whether to apply extra padding
        ///     to the first product image.
        case custom(applyProductFirstImageExtraPadding: Bool)
    }
}
