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

import AiutaKit
import Resolver
import UIKit

public enum Aiuta {
    public struct SkuInfo {
        public let skuId: String
        public let skuCatalog: String
        public let imageUrls: [String]
        public let localizedTitle: String
        public let localizedBrand: String
        public let localizedPrice: String
        public let localizedOldPrice: String?
        public let localizedDiscount: String?

        public init(skuId: String,
                    skuCatalog: String,
                    imageUrls: [String],
                    localizedTitle: String,
                    localizedBrand: String,
                    localizedPrice: String,
                    localizedOldPrice: String? = nil,
                    localizedDiscount: String? = nil) {
            self.skuId = skuId
            self.skuCatalog = skuCatalog
            self.imageUrls = imageUrls
            self.localizedTitle = localizedTitle
            self.localizedBrand = localizedBrand
            self.localizedPrice = localizedPrice
            self.localizedOldPrice = localizedOldPrice
            self.localizedDiscount = localizedDiscount
        }
    }

    public static func setup(apiKey: String) {
        Resolver.register { ApiService(baseUrl: "https://api.aiuta.com", apiKey: apiKey) }
        Resolver.register { AiutaSdkDesignSystem() }.implements(DesignSystem.self)
        Resolver.register { AiutaSdkModelImpl() }.implements(AiutaSdkModel.self)
    }

    public static func tryOn(sku: SkuInfo,
                             withMoreToTryOn relatedSkus: [SkuInfo] = [],
                             in viewController: UIViewController,
                             delegate: AiutaSdkDelegate) {
        viewController.present(AiutaEntryViewController(session: .init(tryOnSku: sku, moreToTryOn: relatedSkus, delegate: delegate)), animated: true)
    }
}

public protocol AiutaSdkDelegate: AnyObject {
    func aiuta(addToWishlist skuId: String)
    func aiuta(addToCart skuId: String)
    func aiuta(showSku skuId: String)
}
