// Copyright 2024 Aiuta USA, Inc
//
// Licensed under the Apache License, Version 2.0 (the "License");
// You may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

extension Aiuta.Product {
    /// Represents pricing details for a product within the Aiuta platform.
    /// To display prices, ensure that the `ProductBarTheme` is configured
    /// with a `Prices` feature.
    public struct Price: Sendable {
        /// The current price of the product, formatted as a localized string.
        /// This value should include the currency symbol and the amount.
        public let current: String

        /// The old price of the product, formatted as a localized string.
        /// This value is optional and, if provided, will be displayed as
        /// a strikethrough near the current price.
        public let old: String?

        /// Creates a new `Price` instance with the specified current and
        /// optional old price values.
        ///
        /// - Parameters:
        ///   - current: The localized current price of the product. This
        ///     should include the currency symbol and the amount.
        ///   - old: The localized old price of the product. This is optional
        ///     and can be used to show a discounted or previous price.
        public init(_ current: String, old: String? = nil) {
            self.current = current
            self.old = old
        }
    }
}
