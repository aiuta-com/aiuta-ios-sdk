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

extension Aiuta.Configuration.Features.TryOn {
    /// Configures the cart functionality for the TryOn feature. You can use the
    /// default configuration or customize the behavior and text content for
    /// cart-related actions.
    public enum Cart {
        /// Use the default cart configuration with a specified handler.
        ///
        /// - Parameters:
        ///   - handler: The handler responsible for managing cart actions.
        case `default`(handler: Handler)

        /// Use a custom cart configuration with specific strings and a handler.
        ///
        /// - Parameters:
        ///   - strings: Custom text content for cart-related actions.
        ///   - handler: The handler responsible for managing cart actions.
        case custom(strings: Strings,
                    handler: Handler)
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.TryOn.Cart {
    /// Defines the text content used for cart-related actions in the TryOn
    /// feature. You can use the default text, provide custom strings, or supply
    /// them through a provider.
    public enum Strings {
        /// Use the default text content for cart-related actions.
        case `default`

        /// Specify custom text content for cart-related actions.
        ///
        /// - Parameters:
        ///   - addToCart: The label for the "Add to Cart" button.
        case custom(addToCart: String)

        /// Use a custom provider to supply text content.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom text content.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.TryOn.Cart.Strings {
    /// A protocol for supplying custom text content dynamically for cart-related
    /// actions. Implement this protocol to provide labels and other text.
    public protocol Provider {
        /// The label for the "Add to Cart" button.
        var addToCart: String { get }
    }
}

// MARK: - Handler

extension Aiuta.Configuration.Features.TryOn.Cart {
    /// A protocol for managing cart-related actions in the TryOn feature.
    /// Implement this protocol to handle products are added to the cart.
    public protocol Handler {
        /// Adds a product to the cart.
        ///
        /// - Parameters:
        ///   - productId: The unique identifier of the product to add.
        @available(iOS 13.0.0, *)
        func addToCart(productId: String) async
    }
}
