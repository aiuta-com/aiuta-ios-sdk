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

final class AiutaTryOnViewController: ViewController<AiutaTryOnView> {
    @Injected private var model: AiutaSdkModel

    private(set) var session: Aiuta.TryOnSession?
    private var sku: Aiuta.SkuInfo?

    private var selector: AiutaPhotoSelectorController?
    private var processor: AiutaProcessingController?
    private var results: AiutaTryOnResultViewController?

    @defaults(key: "lastUploadedImage", defaultValue: nil)
    var lastUploadedImage: Aiuta.UploadedImage?

    convenience init(session: Aiuta.TryOnSession) {
        self.init()
        self.session = session
    }

    override func setup() {
        ui.navBar.onDismiss.subscribe(with: self) { [unowned self] in
            guard ui.mode != .result else {
                ui.mode = .photoSelecting
                return
            }
            dismiss()
        }

        selector = addComponent(AiutaPhotoSelectorController(ui))
        processor = addComponent(AiutaProcessingController(ui))
        results = addComponent(AiutaTryOnResultViewController(ui))

        if let sku = session?.tryOnSku { changeSku(sku) }

        selector?.didPickPhoto.subscribe(with: self) { [unowned self] image in
            processor?.startTryOn(selectedImage: image)
        }

        processor?.didUploadImage.subscribe(with: self) { [unowned self] image in
            lastUploadedImage = image
        }

        processor?.didCompleteProcessing.subscribe(with: self) { [unowned self] operation in
            results?.showResult(operation, sku: sku, original: lastUploadedImage)
        }

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

        model.onChangeHistory.subscribe(with: self) { [unowned self] _ in
            updateHistory()
        }
        updateHistory()

        enableInteractiveDismiss(withTarget: ui.swipeEdge)
    }

    override func whenDidAppear() {
        _ = processor?.checkIsReady()
    }

    func updateHistory() {
        ui.navBar.isActionAvailable = !model.generationHistory.isEmpty
    }

    func changeSku(_ sku: Aiuta.SkuInfo) {
        self.sku = sku
        processor?.sku = sku
        ui.skuBar.sku = sku
        ui.skuBulletin.sku = sku
        results?.moreToTryOn = session?.moreToTryOn.filter { $0 != sku }
        selector?.lastUploadedImage = lastUploadedImage
        processor?.lastUploadedImage = lastUploadedImage
        ui.mode = .photoSelecting
    }

    private func addToCart() {
        guard let skuId = sku?.skuId, let delegate = session?.delegate else { return }
        dismiss()
        delay(.thirdOfSecond) { [delegate] in
            delegate.aiuta(addToCart: skuId)
        }
    }

    private func addToWishlist() {
        guard let skuId = sku?.skuId, let delegate = session?.delegate else { return }
        dismiss()
        delay(.thirdOfSecond) { [delegate] in
            delegate.aiuta(addToWishlist: skuId)
        }
    }
}
