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

@_spi(Aiuta) import AiutaKit

final class SessionModelImpl: SessionModel {
    var activeSku: Aiuta.Product?

    weak var delegate: AiutaSdkDelegate?
    private var wishlist = Set<String>()

    func start(sku: Aiuta.Product, delegate: AiutaSdkDelegate) {
        self.delegate = delegate
        activeSku = sku
    }

    func finish(addingToCart sku: Aiuta.Product?) {
        guard let sku else { return }
        delegate?.aiuta(addToCart: sku.skuId)
    }

    func isInWishlist(_ sku: Aiuta.Product?) -> Bool {
        guard let sku else { return false }
        return wishlist.contains(sku.skuId)
    }

    func toggleWishlist(_ sku: Aiuta.Product?) -> Bool {
        guard let sku else { return false }
        if wishlist.contains(sku.skuId) {
            wishlist.remove(sku.skuId)
            return false
        } else {
            wishlist.insert(sku.skuId)
            return true
        }
    }
}
