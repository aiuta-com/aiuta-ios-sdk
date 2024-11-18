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
    /// This structure represents the information about a SKU in the Aiuta platform.
    public struct Product {
        public let skuId: String
        public let skuCatalog: String?
        public let imageUrls: [String]
        public let localizedTitle: String
        public let localizedBrand: String
        public let localizedPrice: String?
        public let localizedOldPrice: String?
        public let localizedDiscount: String?
        public let additionalShareInfo: String?

        /// - Parameters:
        ///   - skuId: A unique identifier for the SKU.
        ///   - skuCatalog: The catalog identifier the SKU belongs to.
        ///                 See [Digital Try On](https://developer.aiuta.com/products/digital-try-on/Documentation) Api Reference
        ///                 to learn how to find out the catalog name of your SKU.
        ///
        ///                 **Since SDK version 1.1.3 this parameter is optional.**
        ///                 *If not specified the default catalog will be used.*
        ///                 ** (!) It is recommended not to specify a skuCatalog unless it is explicitly necessary.**
        ///
        ///   - imageUrls: A list of URLs pointing to the images of the SKU.
        ///   - localizedTitle: The title of the SKU.
        ///   - localizedBrand: The brand of the SKU.
        ///   - localizedPrice: The price of the SKU. Should be formatted with a currency symbol.
        ///   - localizedOldPrice: The old price of the SKU, if available. Should be formatted with a currency symbol.
        ///   - localizedDiscount: The discount on the SKU, if available. Should be formatted with a percent symbol.
        ///   - additionalShareInfo: Additional information that will be passed to the share along with the generated image.
        ///                          *(!) Some applications do not accept image and text/url for publishing.*
        ///                          *As we find out, such apps will be blacklisted in the next SDK updates.*
        ///                          *Only the image is sent to apps on this list.*
        public init(skuId: String,
                    skuCatalog: String? = nil,
                    imageUrls: [String],
                    localizedTitle: String,
                    localizedBrand: String,
                    localizedPrice: String? = nil,
                    localizedOldPrice: String? = nil,
                    localizedDiscount: String? = nil,
                    additionalShareInfo: String? = nil) {
            self.skuId = skuId
            self.skuCatalog = skuCatalog
            self.imageUrls = imageUrls
            self.localizedTitle = localizedTitle
            self.localizedBrand = localizedBrand
            self.localizedPrice = localizedPrice
            self.localizedOldPrice = localizedOldPrice
            self.localizedDiscount = localizedDiscount
            self.additionalShareInfo = additionalShareInfo
        }
    }

    public typealias SkuInfo = Product
}
