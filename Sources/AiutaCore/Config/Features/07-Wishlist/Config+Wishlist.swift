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
    /// Configures the Wishlist feature, which allows interaction with the host
    /// app's wishlist. You can enable or disable this feature and customize its
    /// behavior with specific icons, strings, and data providers.
    public enum Wishlist {
        /// Disables the Wishlist feature entirely.
        case none

        /// Enables the Wishlist feature with custom settings.
        ///
        /// - Parameters:
        ///   - icons: Icons used for the Wishlist feature.
        ///   - strings: Text content for the Wishlist feature.
        ///   - dataProvider: A provider for managing Wishlist functionality.
        case custom(icons: Icons = .builtIn,
                    strings: Strings = .default,
                    dataProvider: DataProvider)
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.Wishlist {
    /// Defines the icons used in the Wishlist feature. You can use default icons,
    /// provide custom ones, or supply them dynamically through a provider.
    public enum Icons {
        /// Uses the default set of icons provided by the SDK.
        case builtIn

        /// Allows you to specify custom icons for the Wishlist feature.
        ///
        /// - Parameters:
        ///   - wishlist24: The icon displayed for the Wishlist button.
        ///   - wishlistFill24: The icon displayed for the filled Wishlist button.
        case custom(wishlist24: UIImage,
                    wishlistFill24: UIImage)

        /// Allows you to use a custom provider to supply icons dynamically.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom icons.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.Wishlist.Icons {
    /// A protocol for supplying custom icons to the Wishlist feature. Implement
    /// this protocol to provide a custom set of icons dynamically.
    public protocol Provider {
        /// The icon displayed for the Wishlist button.
        var wishlist24: UIImage { get }

        /// The icon displayed for the filled Wishlist button.
        var wishlistFill24: UIImage { get }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.Wishlist {
    /// Defines the text content used in the Wishlist feature. You can use default
    /// text, provide custom strings, or supply them dynamically through a provider.
    public enum Strings {
        /// Uses the default text content provided by the SDK.
        case `default`

        /// Allows you to specify custom text content for the Wishlist feature.
        ///
        /// - Parameters:
        ///   - wishlistButtonAdd: The label for the "Add to Wishlist" button.
        case custom(wishlistButtonAdd: String)

        /// Allows you to use a custom provider to supply text content.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom text content.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.Wishlist.Strings {
    /// A protocol for supplying custom text content to the Wishlist feature.
    /// Implement this protocol to provide button labels and other text.
    public protocol Provider {
        /// The label for the "Add to Wishlist" button.
        var wishlistButtonAdd: String { get }
    }
}

// MARK: - Data Provider

extension Aiuta.Configuration.Features.Wishlist {
    /// A protocol for managing the data flow and operations of the Wishlist
    /// feature. Implement this protocol to control how Wishlist data is stored
    /// and updated.
    public protocol DataProvider {
        /// A list of product IDs currently in the Wishlist.
        @available(iOS 13.0.0, *)
        var wishlistProductIds: Aiuta.Observable<[String]> { get async }

        /// Adds or removes a products from the Wishlist.
        ///
        /// - Parameters:
        ///   - productId: The list of product ids to add or remove.
        ///   - inWishlist: A flag indicating whether the product should be added
        ///     to or removed from the Wishlist.
        @available(iOS 13.0.0, *)
        func setProductInWishlist(productIds: [String], inWishlist: Bool) async
    }
}
