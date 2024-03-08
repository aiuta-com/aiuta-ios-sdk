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

import Kingfisher
import Resolver
import UIKit

@available(iOS 13.0.0, *)
final class AiutaTryOnViewController: ViewController<AiutaTryOnView> {
    @Injected private var model: AiutaSdkModel

    private var selector: AiutaPhotoSelectorController?
    private var processor: AiutaProcessingController?
    private var results: AiutaTryOnResultViewController?

    var hasUploads: Bool {
        !model.uploadsHistory.isEmpty
    }

    convenience init(session: Aiuta.TryOnSession) {
        self.init()
        model.startSession(session)
        preload(session.tryOnSku.imageUrls.first)
        model.uploadsHistory.last?.forEach { lastUploadedImage in
            preload(lastUploadedImage.url)
        }
    }

    override func setup() {
        ui.navBar.onDismiss.subscribe(with: self) { [unowned self] in
            dismiss()
        }

        selector = addComponent(AiutaPhotoSelectorController(ui))
        processor = addComponent(AiutaProcessingController(ui))
        results = addComponent(AiutaTryOnResultViewController(ui))

        ui.poweredBy.onTouchUpInside.subscribe(with: self) { [unowned self] in
            openUrl("https://aiuta.com", anchor: ui.poweredBy, inApp: true)
        }

        ui.resultView.footer.addToCart.onTouchUpInside.subscribe(with: self) { [unowned self] in
            addToCart()
        }

        ui.resultView.footer.addToWishlist.onTouchUpInside.subscribe(with: self) { [unowned self] in
            addToWishlist()
        }

        ui.skuBulletin.primaryButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            addToCart()
        }

        ui.skuBulletin.secondaryButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            addToWishlist()
        }

        ui.navBar.header.action.onTouchUpInside.subscribe(with: self) { [unowned self] in
            present(AiutaGenerationsHistoryViewController())
        }

        ui.skuBar.onTouchUpInside.subscribe(with: self) { [unowned self] in
            showBulletin(ui.skuBulletin)
        }

        model.onChangeState.subscribePast(with: self) { [unowned self] state in
            ui.mode = state
        }

        model.onChangeHistory.subscribe(with: self) { [unowned self] _ in
            updateHistory()
        }
        updateHistory()

        model.onChangeSku.subscribePast(with: self) { [unowned self] sku in
            ui.skuBar.sku = sku
            ui.skuBulletin.sku = sku
        }

        ui.skuBar.sku = model.tryOnSku
        ui.skuBulletin.sku = model.tryOnSku

        enableInteractiveDismiss(withTarget: ui.swipeEdge)
    }

    func updateHistory() {
        ui.navBar.isActionAvailable = !model.generationHistory.isEmpty
    }

    private func addToCart() {
        guard let skuId = model.tryOnSku?.skuId, let delegate = model.delegate else { return }
        dismiss(animated: true) { delay(.moment) { delegate.aiuta(addToCart: skuId) } }
    }

    private func addToWishlist() {
        guard let skuId = model.tryOnSku?.skuId, let delegate = model.delegate else { return }
        dismiss(animated: true) { delay(.moment) { delegate.aiuta(addToWishlist: skuId) } }
    }

    private func preload(_ urlString: String?) {
        model.preloadImage(urlString)
    }
}
