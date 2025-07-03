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

extension Aiuta.Configuration.Features.TryOn.MultiItem {
    /// Configures the cart functionality for the MultiItem TryOn feature. You
    /// can use the default settings or customize the text and behavior to suit
    /// your needs.
    public enum Cart {
        /// Use the default cart configuration with a specified handler to
        /// manage cart actions.
        ///
        /// - Parameters:
        ///   - handler: Defines how cart actions are handled.
        case `default`(handler: Handler)

        /// Use a custom cart configuration with specific text content and a
        /// handler to manage cart actions.
        ///
        /// - Parameters:
        ///   - strings: Custom text content for cart-related actions.
        ///   - handler: Defines how cart actions are handled.
        case custom(strings: Strings,
                    handler: Handler)
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.TryOn.MultiItem.Cart {
    /// Defines the text content used in the cart functionality. You can use
    /// the default text, provide custom strings, or implement a custom provider
    /// to manage the text content.
    public enum Strings {
        /// Use the default text content for the cart functionality.
        case `default`

        /// Specify custom text content for the cart functionality.
        ///
        /// - Parameters:
        ///   - shopTheLook: The label for the "Shop the Look" action.
        case custom(shopTheLook: String)

        /// Use a custom implementation to manage the text content for the cart
        /// functionality.
        ///
        /// - Parameters:
        ///   - provider: An object that conforms to the `Provider` protocol.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.TryOn.MultiItem.Cart.Strings {
    /// A protocol for managing the text content of the cart functionality. You
    /// can implement this protocol to define the label for the "Shop the Look"
    /// action.
    public protocol Provider {
        /// The label for the "Shop the Look" action.
        var shopTheLook: String { get }
    }
}

// MARK: - Handler

extension Aiuta.Configuration.Features.TryOn.MultiItem.Cart {
    /// A protocol for managing cart actions. You can implement this protocol
    /// to define how the "Shop the Look" action is handled.
    public protocol Handler {
        /// Handles the "Shop the Look" action by processing the provided
        /// product IDs.
        ///
        /// - Parameters:
        ///   - productIds: The list of product IDs to include in the action.
        func shopTheLook(with productIds: [String])
    }
}
