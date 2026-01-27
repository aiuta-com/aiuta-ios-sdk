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

extension Aiuta.Configuration.Features {
    /// Wishlist feature configuration.
    public struct Wishlist: Sendable {
        /// Icons for the Wishlist feature.
        public let icons: Icons
        
        /// Text content for the Wishlist feature.
        public let strings: Strings
        
        /// Provider for managing Wishlist functionality.
        public let dataProvider: DataProvider
        
        /// Creates a Wishlist feature configuration.
        ///
        /// - Parameters:
        ///   - icons: Icons for the Wishlist feature.
        ///   - strings: Text content for the Wishlist feature.
        ///   - dataProvider: Provider for managing Wishlist functionality.
        public init(icons: Icons,
                    strings: Strings,
                    dataProvider: DataProvider) {
            self.icons = icons
            self.strings = strings
            self.dataProvider = dataProvider
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.Wishlist {
    /// Icons for the Wishlist feature.
    public struct Icons: Sendable {
        /// Icon displayed for the Wishlist button.
        public let wishlist24: UIImage
        
        /// Icon displayed for the filled Wishlist button.
        public let wishlistFill24: UIImage
        
        /// Creates custom icons.
        ///
        /// - Parameters:
        ///   - wishlist24: Icon displayed for the Wishlist button.
        ///   - wishlistFill24: Icon displayed for the filled Wishlist button.
        public init(wishlist24: UIImage,
                    wishlistFill24: UIImage) {
            self.wishlist24 = wishlist24
            self.wishlistFill24 = wishlistFill24
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.Wishlist {
    /// Text content for the Wishlist feature.
    public struct Strings: Sendable {
        /// Label for the "Add to Wishlist" button.
        public let wishlistButtonAdd: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - wishlistButtonAdd: Label for the "Add to Wishlist" button.
        public init(wishlistButtonAdd: String) {
            self.wishlistButtonAdd = wishlistButtonAdd
        }
    }
}

// MARK: - Data Provider

extension Aiuta.Configuration.Features.Wishlist {
    /// Protocol for managing the data flow and operations of the Wishlist feature.
    public protocol DataProvider {
        /// List of product IDs currently in the Wishlist.
        @available(iOS 13.0.0, *)
        var wishlistProductIds: Aiuta.Observable<[String]> { get async }

        /// Adds or removes products from the Wishlist.
        ///
        /// - Parameters:
        ///   - productId: List of product ids to add or remove.
        ///   - inWishlist: Flag indicating whether the product should be added or removed.
        @available(iOS 13.0.0, *)
        func setProductInWishlist(productIds: [String], inWishlist: Bool) async
    }
}
