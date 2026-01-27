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

// MARK: - Outfit

extension Aiuta.Configuration.Features.TryOn.Cart {
    /// Configuration for outfit/multi-item cart functionality ("Shop the Look").
    public struct Outfit: Sendable {
        /// Text content for outfit cart actions.
        public let strings: Strings
        
        /// Handler responsible for managing outfit cart actions.
        public let handler: Handler
        
        /// Creates an outfit cart configuration.
        ///
        /// - Parameters:
        ///   - strings: Text content for outfit cart actions.
        ///   - handler: Handler responsible for managing outfit cart actions.
        public init(strings: Strings,
                    handler: Handler) {
            self.strings = strings
            self.handler = handler
        }
    }
}

// MARK: - Outfit Strings

extension Aiuta.Configuration.Features.TryOn.Cart.Outfit {
    /// Text content for outfit cart actions.
    public struct Strings: Sendable {
        /// Label for the "Shop the Look" action.
        public let addToCartOutfit: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - addToCartOutfit: Label for the "Shop the Look" action.
        public init(addToCartOutfit: String) {
            self.addToCartOutfit = addToCartOutfit
        }
    }
}

// MARK: - Outfit Handler

extension Aiuta.Configuration.Features.TryOn.Cart.Outfit {
    /// Protocol for managing outfit cart actions.
    public protocol Handler {
        /// Handles the "Shop the Look" action by processing multiple product IDs.
        ///
        /// - Parameters:
        ///   - productIds: List of product IDs to include in the outfit.
        func addToCartOutfit(productIds: [String])
    }
}
