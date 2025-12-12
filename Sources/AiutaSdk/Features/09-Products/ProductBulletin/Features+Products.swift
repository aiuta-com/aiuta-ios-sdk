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
import AiutaCore
import AVFoundation
import UIKit

extension Sdk.Features {
    @available(iOS 13.0, *)
    final class ProductBulletinController: ComponentController<Sdk.UI.Products.ProductBulletin> {
        @injected private var wishlist: Sdk.Core.Wishlist
        @injected private var tracker: AnalyticTracker
        @injected private var session: Sdk.Core.Session
        
        override func setup() {
            ui.onTapImage.subscribe(with: self) { [unowned self] index in
                guard let sku = ui.product, !sku.imageUrls.isEmpty else { return }
                vc?.cover(GalleryViewController(DataProvider(sku.imageUrls), start: index))
            }

            ui.cartButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
                guard let sku = ui.product, let page = (vc as? PageRepresentable)?.page else { return }
                tracker.track(.results(event: .productAddToCart, pageId: page, productIds: [sku.id]))
                vc?.dismissAll { [session] in
                    session.finish(addingToCart: [sku])
                }
            }

            ui.wishButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
                guard let sku = ui.product, let page = (vc as? PageRepresentable)?.page else { return }
                ui.wishButton.isSelected = wishlist.toggleWishlist(sku)
                if ui.wishButton.isSelected {
                    tracker.track(.results(event: .productAddToWishlist, pageId: page, productIds: [sku.id]))
                }
            }

            wishlist.onWishlistChange.subscribe(with: self) { [unowned self] in
                ui.wishButton.isSelected = wishlist.isInWishlist(ui.product)
            }
        }
        
        func show(product: Aiuta.Product?) {
            guard let product else { return }
            ui.product = product
            ui.wishButton.isSelected = wishlist.isInWishlist(product)
            showBulletin(ui)
        }
    }
}
