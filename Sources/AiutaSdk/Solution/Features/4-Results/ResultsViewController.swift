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
import UIKit

@available(iOS 13.0.0, *)
final class ResulstsViewController: ViewController<ResultsView> {
    @injected private var tryOnModel: TryOnModel
    @injected private var history: HistoryModel
    @injected private var session: SessionModel
    @injected private var tracker: AnalyticTracker
    @injected private var watermarker: Watermarker

    private var selector: PhotoSelectorController?
    private var originalPresenterAlpha: CGFloat = 1

    override func setup() {
        selector = addComponent(PhotoSelectorController(ui))

        ui.navBar.onClose.subscribe(with: self) { [unowned self] in
            dismissAll()
        }

        ui.navBar.onAction.subscribe(with: self) { [unowned self] in
            popoverOrCover(HistoryViewController())
        }

        ui.skuSheet.content.addToCart.onTouchUpInside.subscribe(with: self) { [unowned self] in
            dismissAll()
        }

        ui.pager.pages.forEach { page in
            addComponent(FeedbackViewController(page))

            page.shadowControls.newPhoto.onTouchUpInside.subscribe(with: self) { [unowned self] in
                session.track(.results(event: .pickOtherPhoto, page: self.page, product: ui.pager.currentItem?.sku))
                selector?.choosePhoto(withHistoryPrefered: false)
            }

            page.shadowControls.share.onTouchUpInside.subscribe(with: self) { [unowned self] in
                shareCurrent()
            }

            page.shadowControls.wish.onTouchUpInside.subscribe(with: self) { [unowned self] in
                toggleCurrentWish()
            }

            page.shadowControls.button.onTouchUpInside.subscribe(with: self) { [unowned self] in
                enterFullScreen()
            }
        }

        selector?.didPick.subscribe(with: self) { [unowned self] source in
            Task {
                _ = try? await source.prefetch(.hiResImage, breadcrumbs: .init())
                replace(with: ProcessingViewController(source))
            }
        }

        ui.didBlackout.subscribe(with: self) { progress in
            BulletinWall.current?.intence = progress
        }

        history.generated.onUpdate.subscribe(with: self) { [unowned self] in
            ui.navBar.isActionAvailable = history.hasGenerations
        }

        ui.pager.onSwipePage.subscribe(with: self) { [unowned self] _ in
            ui.skuSheet.sku = ui.pager.currentItem?.sku
            tracker.track(.results(.view(sku: ui.skuSheet.sku, index: ui.pager.pageIndex)))
        }

        ui.skuSheet.onTapImage.subscribe(with: self) { [unowned self] index in
            guard let sku = ui.pager.currentItem?.sku, !sku.imageUrls.isEmpty else { return }
            cover(GalleryViewController(DataProvider(sku.imageUrls), start: index))
        }

        ui.skuSheet.content.addToCart.onTouchUpInside.subscribe(with: self) { [unowned self] in
            let sku = ui.pager.currentItem?.sku
            session.track(.results(event: .productAddToCart, page: page, product: sku))
            dismissAll { [session, tracker] in
                session.finish(addingToCart: sku)
                tracker.track(.session(.finish(action: .addToCart, origin: .resultsScreen, sku: sku)))
            }
        }

        ui.fitDisclaimer.button.onTouchUpInside.subscribe(with: self) { [unowned self] in
            showBulletin(TryOnView.FitDisclaimerBulletin())
        }

        session.onWishlistChange.subscribe(with: self) { [unowned self] in
            ui.pager.pages.forEach { $0.updateWish() }
        }

        tryOnModel.sessionResults.onUpdate.subscribe(with: self) { [unowned self] in
            if tryOnModel.sessionResults.isEmpty {
                replace(with: TryOnViewController())
            }
        }

        ui.pager.data = tryOnModel.sessionResults
        ui.navBar.isActionAvailable = history.hasGenerations
        ui.skuSheet.sku = ui.pager.currentItem?.sku

        session.track(.page(page: page, product: ui.skuSheet.sku))
        tracker.track(.results(.open(sku: ui.skuSheet.sku)))
        tracker.track(.results(.view(sku: ui.skuSheet.sku, index: 0)))
    }

    private func toggleCurrentWish() {
        let isWish = session.toggleWishlist(ui.pager.currentItem?.sku)
        if let skuId = ui.pager.currentItem?.sku.skuId {
            session.delegate?.aiuta(addToWishlist: skuId)
            if isWish {
                session.track(.results(event: .productAddToWishlist, page: page, product: ui.pager.currentItem?.sku))
            }
        }
        ui.pager.pages.forEach { page in
            page.updateWish()
        }
    }

    private func shareCurrent() {
        guard let result = ui.pager.currentItem else { return }
        let generatedImage = result.image
        let sku = result.sku
        Task {
            guard let image = try? await generatedImage.fetch(breadcrumbs: Breadcrumbs()) else { return }
            tracker.track(.share(.start(origin: .resultsScreen, count: 1, text: sku.additionalShareInfo)))
            ui.canBlackout = false
            let result = await share(image: watermarker.watermark(image),
                                     additions: [sku.additionalShareInfo].compactMap { $0 })
            ui.canBlackout = true
            switch result {
                case let .succeeded(activity):
                    tracker.track(.share(.success(origin: .resultsScreen, count: 1, activity: activity, text: sku.additionalShareInfo)))
                    session.track(.results(event: .resultShared, page: page, product: sku))
                case let .canceled(activity):
                    tracker.track(.share(.cancelled(origin: .resultsScreen, count: 1, activity: activity)))
                case let .failed(activity, error):
                    tracker.track(.share(.failed(origin: .resultsScreen, count: 1, activity: activity, error: error)))
            }
        }
    }

    private func enterFullScreen() {
        let gallery = GalleryViewController(TransformDataProvider(input: tryOnModel.sessionResults, transform: { $0.image }), start: ui.pager.pageIndex)
        gallery.willShare.subscribe(with: self) { [unowned self] generatedImage, index, vc in
            Task {
                guard let image = try? await generatedImage.fetch(breadcrumbs: Breadcrumbs()) else { return }
                let sku = tryOnModel.sessionResults.items[safe: index]?.sku
                tracker.track(.share(.start(origin: .history, count: 1, text: sku?.additionalShareInfo)))
                let result = await vc.share(image: watermarker.watermark(image),
                                            additions: [sku?.additionalShareInfo].compactMap { $0 })
                switch result {
                    case let .succeeded(activity):
                        tracker.track(.share(.success(origin: .resultsFullScreen, count: 1, activity: activity, text: sku?.additionalShareInfo)))
                        session.track(.results(event: .resultShared, page: page, product: sku))
                    case let .canceled(activity):
                        tracker.track(.share(.cancelled(origin: .resultsFullScreen, count: 1, activity: activity)))
                    case let .failed(activity, error):
                        tracker.track(.share(.failed(origin: .resultsFullScreen, count: 1, activity: activity, error: error)))
                }
            }
        }
        cover(gallery)
    }
}

@available(iOS 13.0.0, *)
extension ResulstsViewController: PageRepresentable {
    var page: Aiuta.Event.Page { .results }
    var isSafeToDismiss: Bool { false }
}
