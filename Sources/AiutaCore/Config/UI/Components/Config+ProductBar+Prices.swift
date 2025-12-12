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

extension Aiuta.Configuration.UserInterface.ProductBarTheme {
    /// Configures the pricing options for the product bar.
    ///
    /// This setting determines how prices are displayed in the product bar. You can
    /// use the default configuration, hide prices entirely, or define a custom setup
    /// to better align with your app's design and functionality.
    public enum Prices {
        /// Do not display prices in the product bar.
        case none

        /// Use the default pricing configuration provided by the SDK.
        case `default`

        /// Define a custom pricing configuration for the product bar.
        ///
        /// - Parameters:
        ///   - typography: Configures the typography for product prices.
        ///   - colors: Configures the color scheme for product prices.
        case custom(typography: Typography,
                    colors: Colors)
    }
}

// MARK: - Typography

extension Aiuta.Configuration.UserInterface.ProductBarTheme.Prices {
    /// Configures the typography for product bar prices.
    ///
    /// Typography defines the text styles applied to price elements. You can use
    /// the default typography or define custom styles to match your app's design
    /// language.
    public enum Typography {
        /// Use the default typography for product bar prices.
        case `default`

        /// Define custom typography for product bar prices.
        ///
        /// - Parameters:
        ///   - price: The text style for product prices.
        case custom(price: Aiuta.Configuration.TextStyle)

        /// Use a custom typography provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom typography.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.ProductBarTheme.Prices.Typography {
    /// Supplies custom typography for product bar prices.
    ///
    /// This protocol defines the required text style for product prices.
    /// - Note: Use the `Aiuta.Configuration.Typography` typealias for convenience.
    public protocol Provider {
        /// The text style for product prices.
        var price: Aiuta.Configuration.TextStyle { get }
    }
}

// MARK: - Colors

extension Aiuta.Configuration.UserInterface.ProductBarTheme.Prices {
    /// Configures the color scheme for product bar prices.
    ///
    /// Colors define the visual style of price elements, such as discounted prices.
    /// You can use the default color scheme or define custom colors to match your
    /// app's design language.
    public enum Colors {
        /// Use the default color scheme for product bar prices.
        case aiutaLight

        /// Define custom colors for product bar prices.
        ///
        /// - Parameters:
        ///   - discountedPrice: The color for discounted prices.
        case custom(discountedPrice: UIColor)

        /// Use a custom colors provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom colors.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.ProductBarTheme.Prices.Colors {
    /// Supplies custom colors for product bar prices.
    ///
    /// This protocol defines the required colors, such as the color for discounted
    /// prices.
    /// - Note: Use the `Aiuta.Configuration.Colors` typealias for convenience.
    public protocol Provider {
        /// The color for discounted prices.
        var discountedPrice: UIColor { get }
    }
}
