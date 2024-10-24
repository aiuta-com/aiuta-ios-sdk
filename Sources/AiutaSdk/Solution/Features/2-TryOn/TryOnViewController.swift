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
import Kingfisher
import Resolver
import StoreKit
import UIKit

@available(iOS 13.0.0, *)
final class TryOnViewController: ViewController<TryOnView> {
    @injected private var history: HistoryModel
    @injected private var session: SessionModel
    private var selector: PhotoSelectorController?

    override func setup() {
        selector = addComponent(PhotoSelectorController(ui))

        ui.navBar.onClose.subscribe(with: self) { [unowned self] in
            dismissAll()
        }

        ui.navBar.onAction.subscribe(with: self) { [unowned self] in
            popoverOrCover(HistoryViewController())
        }

        ui.uploadButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            selector?.choosePhoto()
        }

        ui.changeButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            selector?.choosePhoto()
        }

        selector?.didPick.subscribe(with: self) { [unowned self] source in
            replace(with: ProcessingViewController(source))
        }

        ui.tryOnBar.tryOnButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            guard let source = ui.lastImage.source else {
                selector?.choosePhoto()
                return
            }
            replace(with: ProcessingViewController(source))
        }

        ui.tryOnBar.productButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            showBulletin(ui.skuBulletin)
        }

        history.uploaded.onUpdate.subscribe(with: self) { [unowned self] in
            updateUploads(animated: true)
        }

        history.generated.onUpdate.subscribe(with: self) { [unowned self] in
            ui.navBar.isActionAvailable = history.hasGenerations
        }

        ui.skuBulletin.onTapImage.subscribe(with: self) { [unowned self] index in
            guard let sku = session.activeSku, !sku.imageUrls.isEmpty else { return }
            cover(GalleryViewController(DataProvider(sku.imageUrls), start: index))
        }

        ui.skuBulletin.cartButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            if let skuId = session.activeSku?.skuId {
                session.delegate?.aiuta(eventOccurred: .results(pageId: page, event: .productAddToCart, productId: skuId))
            }
            dismissAll { [session] in
                session.finish(addingToCart: session.activeSku)
            }
        }

        ui.skuBulletin.wishButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            ui.skuBulletin.wishButton.isSelected = session.toggleWishlist(session.activeSku)
            if ui.skuBulletin.wishButton.isSelected, let skuId = session.activeSku?.skuId {
                session.delegate?.aiuta(eventOccurred: .results(pageId: page, event: .productAddToWishlist, productId: skuId))
            }
        }

        session.onWishlistChange.subscribe(with: self) { [unowned self] in
            ui.skuBulletin.wishButton.isSelected = session.isInWishlist(session.activeSku)
        }

        updateUploads()
        ui.tryOnBar.product = session.activeSku
        ui.navBar.isActionAvailable = history.hasGenerations
        ui.skuBulletin.sku = session.activeSku
        ui.skuBulletin.wishButton.isSelected = session.isInWishlist(session.activeSku)

        session.delegate?.aiuta(eventOccurred: .page(pageId: page))
    }

    private func updateUploads(animated: Bool = false) {
        let source = history.uploaded.items.first
        ui.lastImage.source = source
        ui.placeholder.view.isVisible = source.isNil
        ui.uploadButton.view.isVisible = source.isNil
        ui.changeButton.view.isVisible = source.isSome
        ui.disclaimer.view.isVisible = source.isNil
        ui.tryOnBar.view.isVisible = source.isSome
        if animated {
            ui.lastImage.animations.transition(.transitionCrossDissolve, duration: .quarterOfSecond)
        }
    }
}

@available(iOS 13.0.0, *)
extension TryOnViewController: PageRepresentable {
    var page: Aiuta.Event.Page { .imagePicker }
    var isSafeToDismiss: Bool { true }
}
