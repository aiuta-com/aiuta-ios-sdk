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
    /// Product bar theme configuration.
    public struct ProductBarTheme: Sendable {
        /// Icons used in the product bar.
        public let icons: Icons
        
        /// Typography for product bar text.
        public let typography: Typography
        
        /// Behavior settings for the product bar.
        public let settings: Settings
        
        /// Price display configuration. Set to nil to hide prices.
        public let prices: Prices?
        
        /// Creates a custom product bar theme.
        ///
        /// - Parameters:
        ///   - icons: Icons used in the product bar.
        ///   - typography: Typography for product bar text.
        ///   - settings: Behavior settings for the product bar.
        ///   - prices: Price display configuration. Set to nil to hide prices.
        public init(icons: Icons,
                    typography: Typography,
                    settings: Settings,
                    prices: Prices?) {
            self.icons = icons
            self.typography = typography
            self.settings = settings
            self.prices = prices
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.UserInterface.ProductBarTheme {
    /// Icon configuration for the product bar.
    public struct Icons: Sendable {
        /// The icon displayed on compact product bar to open details.
        public let arrow16: UIImage
        
        /// Creates custom icon configuration.
        ///
        /// - Parameters:
        ///   - arrow16: The icon displayed on compact product bar to open details.
        public init(arrow16: UIImage) {
            self.arrow16 = arrow16
        }
    }
}

// MARK: - Typography

extension Aiuta.Configuration.UserInterface.ProductBarTheme {
    /// Typography configuration for product bar text.
    public struct Typography: Sendable {
        /// The text style for product names.
        public let product: Aiuta.Configuration.TextStyle
        
        /// The text style for brand names.
        public let brand: Aiuta.Configuration.TextStyle
        
        /// Creates custom typography configuration.
        ///
        /// - Parameters:
        ///   - product: The text style for product names.
        ///   - brand: The text style for brand names.
        public init(product: Aiuta.Configuration.TextStyle,
                    brand: Aiuta.Configuration.TextStyle) {
            self.product = product
            self.brand = brand
        }
    }
}

// MARK: - Settings

extension Aiuta.Configuration.UserInterface.ProductBarTheme {
    /// Behavior settings for the product bar.
    public struct Settings: Sendable {
        /// Whether to apply extra padding to the first product image.
        public let applyProductFirstImageExtraPadding: Bool
        
        /// Creates custom settings configuration.
        ///
        /// - Parameters:
        ///   - applyProductFirstImageExtraPadding: Whether to apply extra padding to the first product image.
        public init(applyProductFirstImageExtraPadding: Bool) {
            self.applyProductFirstImageExtraPadding = applyProductFirstImageExtraPadding
        }
    }
}
