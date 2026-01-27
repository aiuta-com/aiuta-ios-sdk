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
    /// Pricing configuration for the product bar.
    public struct Prices: Sendable {
        /// Typography for product prices.
        public let typography: Typography
        
        /// Color scheme for product prices.
        public let colors: Colors
        
        /// Creates a custom pricing configuration.
        ///
        /// - Parameters:
        ///   - typography: Typography for product prices.
        ///   - colors: Color scheme for product prices.
        public init(typography: Typography,
                    colors: Colors) {
            self.typography = typography
            self.colors = colors
        }
    }
}

// MARK: - Typography

extension Aiuta.Configuration.UserInterface.ProductBarTheme.Prices {
    /// Typography configuration for product bar prices.
    public struct Typography: Sendable {
        /// The text style for product prices.
        public let price: Aiuta.Configuration.TextStyle
        
        /// Creates custom typography configuration.
        ///
        /// - Parameters:
        ///   - price: The text style for product prices.
        public init(price: Aiuta.Configuration.TextStyle) {
            self.price = price
        }
    }
}

// MARK: - Colors

extension Aiuta.Configuration.UserInterface.ProductBarTheme.Prices {
    /// Color scheme for product bar prices.
    public struct Colors: Sendable {
        /// The color for discounted prices.
        public let discountedPrice: UIColor
        
        /// Creates custom color configuration.
        ///
        /// - Parameters:
        ///   - discountedPrice: The color for discounted prices.
        public init(discountedPrice: UIColor) {
            self.discountedPrice = discountedPrice
        }
    }
}
