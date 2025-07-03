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

@available(iOS 13.0.0, *)
extension Sdk.Core {
    final class WishlistImpl: Wishlist {
        @injected var config: Sdk.Configuration

        let onWishlistChange = Signal<Void>()
        private var wishlistProductIds: Set<String> = []

        func isInWishlist(_ sku: Aiuta.Product?) -> Bool {
            guard let sku else { return false }
            return wishlistProductIds.contains(sku.id)
        }

        func toggleWishlist(_ sku: Aiuta.Product?) -> Bool {
            guard let sku else { return false }
            let isInWishlist = isInWishlist(sku)
            if isInWishlist { wishlistProductIds.remove(sku.id) }
            else { wishlistProductIds.insert(sku.id) }
            Task { await setProductInWishlist(productId: sku.id, inWishlist: !isInWishlist) }
            onWishlistChange.fire()
            return !isInWishlist
        }

        init() {
            Task { await subscribeForChanges() }
        }

        @MainActor func subscribeForChanges() async {
            let wishlist = await config.features.wishlist.dataProvider?.wishlistProductIds
            guard let wishlist else { return }

            wishlist.didChange.task(with: self) { [unowned self] in
                let wishlist = await config.features.wishlist.dataProvider?.wishlistProductIds
                guard let wishlist else { return }
                wishlistProductIds = Set(wishlist.value)
                onWishlistChange.fire()
            }

            wishlistProductIds = Set(wishlist.value)
            onWishlistChange.fire()
        }

        @MainActor func setProductInWishlist(productId: String, inWishlist: Bool) async {
            guard let dataProvider = config.features.wishlist.dataProvider else { return }
            await dataProvider.setProductInWishlist(productId: productId, inWishlist: inWishlist)
        }
    }
}
