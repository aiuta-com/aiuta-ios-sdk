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

import Foundation

extension Aiuta {
    /// Represents a product within the Aiuta platform. This structure contains
    /// essential details about a product, such as its identifier, title, brand,
    /// associated images, and pricing information.
    public struct Product: Codable, Sendable {
        /// A unique identifier for the product. This value is used to
        /// distinguish the product across the platform. This identifier
        /// must match the identifiers provided to Aiuta for training the
        /// try-on models.
        public let id: String

        /// The title or name of the product. This is typically displayed
        /// prominently in the user interface.
        public let title: String

        /// The brand associated with the product. This value helps identify
        /// the manufacturer or provider of the product.
        public let brand: String

        /// A collection of URLs pointing to images of the product. These
        /// images are typically used for visual representation in the UI.
        /// Should contain at least one URL. Flatlay image must be the
        /// first in the list if `ProductBarTheme` has enabled
        /// `applyProductFirstImageExtraPadding` toggle.
        public let imageUrls: [String]

        /// The pricing details of the product. This includes the current
        /// price and, optionally, an old price to indicate discounts.
        public let price: Price?

        /// Initializes a new `Product` instance with the provided details.
        ///
        /// - Parameters:
        ///   - id: A unique identifier for the product.
        ///   - title: The name or title of the product.
        ///   - brand: The brand associated with the product.
        ///   - imageUrls: A list of URLs for the product's images. Should
        ///            contain at least one URL. Flatlay image should be
        ///            the first in the list.
        ///   - price: The pricing details of the product. This is optional
        ///            and can be omitted if pricing is not available, or
        ///            sould not be displayed in the Aiuta SDK UI.
        public init(id: String,
                    title: String,
                    brand: String,
                    imageUrls: [String],
                    price: Price? = nil) {
            self.id = id
            self.title = title
            self.brand = brand
            self.imageUrls = imageUrls
            self.price = price
        }
    }

    /// A collection of products. This typealias is used to simplify the
    /// representation of a list of `Product` instances.
    public typealias Products = [Product]
}

extension Aiuta.Products {
    /// A computed property that returns an array of product identifiers.
    public var ids: [String] {
        map { $0.id }
    }
}

extension Aiuta.Product: Equatable {
    /// Compares two `Product` instances for equality based on their identifiers.
    public static func == (lhs: Aiuta.Product, rhs: Aiuta.Product) -> Bool {
        lhs.id == rhs.id
    }
}
