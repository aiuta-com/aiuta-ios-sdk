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
import UIKit

@available(iOS 13.0.0, *)
final class AiutaTryOnViewController: ViewController<AiutaTryOnView> {
    @injected private var model: AiutaSdkModel
    @injected private var configuration: Aiuta.Configuration
    @injected private var tracker: AnalyticTracker

    private var selector: AiutaPhotoSelectorController?
    private var processor: AiutaProcessingController?
    private var results: AiutaTryOnResultViewController?
    private var isSessionInterrupted = false

    var hasUploads: Bool {
        !model.uploadsHistory.isEmpty
    }

    convenience init(session: Aiuta.TryOnSession) {
        self.init()
        model.startSession(session)
    }

    override func prepare() {
        hero.isEnabled = true
        hero.modalAnimationType = .selectBy(presenting: .push(direction: .left),
                                            dismissing: .pull(direction: .right))
    }

    override func setup() {
        ui.navBar.onDismiss.subscribe(with: self) { [unowned self] in
            tracker.track(.session(.finish(action: .none, origin: .mainScreen, sku: model.tryOnSku)))
            dismiss()
        }

        selector = addComponent(AiutaPhotoSelectorController(ui))
        processor = addComponent(AiutaProcessingController(ui))
        results = addComponent(AiutaTryOnResultViewController(ui))

        ui.poweredBy.onTouchUpInside.subscribe(with: self) { [unowned self] in
            openUrl("https://aiuta.com", anchor: ui.poweredBy, inApp: true)
        }

        ui.resultView.footer.addToCart.onTouchUpInside.subscribe(with: self) { [unowned self] in
            addToCart(.resultsScreen)
        }

        ui.resultView.footer.addToWishlist.onTouchUpInside.subscribe(with: self) { [unowned self] in
            addToWishlist(.resultsScreen)
        }

        ui.skuBulletin.primaryButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            addToCart(.skuPopup)
        }

        ui.skuBulletin.secondaryButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            addToWishlist(.skuPopup)
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
        ui.navBar.isActionEnabled = configuration.behavior.isHistoryAvailable

        enableInteractiveDismiss(withTarget: ui.swipeEdge)
        
        tracker.track(.mainScreen(.open(lastPhotosCount: model.uploadsHistory.last?.count ?? 0)))
    }

    override func whenDettached() {
        if isSessionInterrupted {
            tracker.track(.session(.finish(action: .none, origin: .mainScreen, sku: model.tryOnSku)))
        }
    }

    override func whenDismiss(interactive: Bool) {
        isSessionInterrupted = interactive
    }

    override func whenCancelDismiss() {
        isSessionInterrupted = false
    }

    func updateHistory() {
        ui.navBar.isActionAvailable = !model.generationHistory.isEmpty
    }

    private func addToCart(_ origin: AnalyticEvent.Session.Origin) {
        guard let sku = model.tryOnSku, let delegate = model.delegate else { return }
        dismiss(animated: true) { delay(.moment) { delegate.aiuta(addToCart: sku.skuId) } }
        tracker.track(.session(.finish(action: .addToCart, origin: origin, sku: sku)))
    }

    private func addToWishlist(_ origin: AnalyticEvent.Session.Origin) {
        guard let sku = model.tryOnSku, let delegate = model.delegate else { return }
        dismiss(animated: true) { delay(.moment) { delegate.aiuta(addToWishlist: sku.skuId) } }
        tracker.track(.session(.finish(action: .addToWishlist, origin: origin, sku: sku)))
    }

    private func preload(_ urlString: String?) {
        model.preloadImage(urlString)
    }
}

@available(iOS 13.0.0, *)
extension AiutaTryOnViewController: UIPopoverPresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
}
