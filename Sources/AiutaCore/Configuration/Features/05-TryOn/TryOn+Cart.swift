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
    /// Cart functionality configuration for the TryOn feature.
    public struct Cart: Sendable {
        /// Text content for cart-related actions.
        public let strings: Strings
        
        /// Handler responsible for managing cart actions.
        public let handler: Handler
        
        /// Optional outfit/multi-item cart functionality ("Shop the Look").
        public let outfit: Outfit?
        
        /// Creates a cart configuration.
        ///
        /// - Parameters:
        ///   - strings: Text content for cart-related actions.
        ///   - handler: Handler responsible for managing cart actions.
        ///   - outfit: Optional outfit/multi-item cart functionality.
        public init(strings: Strings,
                    handler: Handler,
                    outfit: Outfit?) {
            self.strings = strings
            self.handler = handler
            self.outfit = outfit
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.TryOn.Cart {
    /// Text content for cart-related actions.
    public struct Strings: Sendable {
        /// Label for the "Add to Cart" button.
        public let addToCart: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - addToCart: Label for the "Add to Cart" button.
        public init(addToCart: String) {
            self.addToCart = addToCart
        }
    }
}

// MARK: - Handler

extension Aiuta.Configuration.Features.TryOn.Cart {
    /// A protocol for managing cart-related actions in the TryOn feature.
    ///
    /// Implement this protocol to handle when products are added to the cart.
    public protocol Handler {
        /// Adds a product to the cart.
        ///
        /// - Parameters:
        ///   - productId: Unique identifier of the product to add.
        @available(iOS 13.0.0, *)
        func addToCart(productId: String) async
    }
}
