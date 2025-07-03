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
    @injected private var tryOn: Sdk.Core.TryOn
    @injected private var history: Sdk.Core.History
    @injected private var session: Sdk.Core.Session
    @injected private var wishlist: Sdk.Core.Wishlist
    @injected private var tracker: AnalyticTracker
    @injected private var watermarker: Watermarker
    @injected private var config: Sdk.Configuration

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
                tracker.track(.results(event: .pickOtherPhoto, pageId: self.page,
                                       productIds: [ui.pager.currentItem?.sku].compactMap { $0?.id }))
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
                replace(with: ProcessingViewController(source, origin: .retakeButton))
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
        }

        ui.skuSheet.onTapImage.subscribe(with: self) { [unowned self] index in
            guard let sku = ui.pager.currentItem?.sku, !sku.imageUrls.isEmpty else { return }
            cover(GalleryViewController(DataProvider(sku.imageUrls), start: index))
        }

        ui.skuSheet.content.addToCart.onTouchUpInside.subscribe(with: self) { [unowned self] in
            let sku = ui.pager.currentItem?.sku
            tracker.track(.results(event: .productAddToCart, pageId: page, productIds: [sku].compactMap { $0?.id }))
            dismissAll { [session] in
                session.finish(addingToCart: sku)
            }
        }

        ui.fitDisclaimer.button.onTouchUpInside.subscribe(with: self) { [unowned self] in
            showBulletin(Sdk.UI.TryOn.FitDisclaimerBulletin())
        }

        wishlist.onWishlistChange.subscribe(with: self) { [unowned self] in
            ui.pager.pages.forEach { $0.updateWish() }
        }

        tryOn.sessionResults.onUpdate.subscribe(with: self) { [unowned self] in
            if tryOn.sessionResults.isEmpty {
                replace(with: Sdk.Features.TryOn())
            }
        }

        ui.pager.data = tryOn.sessionResults
        ui.navBar.isActionAvailable = history.hasGenerations
        ui.skuSheet.sku = ui.pager.currentItem?.sku

        tracker.track(.page(pageId: page, productIds: [ui.skuSheet.sku].compactMap { $0?.id }))
    }

    private func toggleCurrentWish() {
        let isWish = wishlist.toggleWishlist(ui.pager.currentItem?.sku)
        if let skuId = ui.pager.currentItem?.sku.id {
            if isWish {
                tracker.track(.results(event: .productAddToWishlist, pageId: page, productIds: [skuId]))
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
            ui.pager.currentPage?.shadowControls.share.activity.start()
            guard let image = try? await generatedImage.fetch(breadcrumbs: Breadcrumbs()) else {
                ui.pager.currentPage?.shadowControls.share.activity.stop()
                return
            }

            tracker.track(.share(event: .initiated, pageId: page, productIds: [sku.id]))
            ui.canBlackout = false
            let attachment = try? await config.features.share.additionalTextProvider?.getShareText(productIds: [sku.id])
            ui.pager.currentPage?.shadowControls.share.activity.stop()

            let result = await share(image: watermarker.watermark(image),
                                     additions: [attachment].compactMap { $0 })
            ui.canBlackout = true
            switch result {
                case let .succeeded(activity):
                    tracker.track(.share(event: .succeeded(targetId: activity), pageId: page, productIds: [sku.id]))
                case let .canceled(activity):
                    tracker.track(.share(event: .canceled(targetId: activity), pageId: page, productIds: [sku.id]))
                case let .failed(activity, _):
                    tracker.track(.share(event: .failed(targetId: activity), pageId: page, productIds: [sku.id]))
            }
        }
    }

    private func enterFullScreen() {
        let gallery = GalleryViewController(TransformDataProvider(input: tryOn.sessionResults, transform: { $0.image }), start: ui.pager.pageIndex)
        gallery.willShare.subscribe(with: self) { [unowned self] generatedImage, index, vc in
            Task {
                gallery.ui.activity.start()
                guard let image = try? await generatedImage.fetch(breadcrumbs: Breadcrumbs()) else {
                    gallery.ui.activity.stop()
                    return
                }

                let productIds = [tryOn.sessionResults.items[safe: index]?.sku].compactMap { $0?.id }
                tracker.track(.share(event: .initiated, pageId: page, productIds: productIds))
                let attachment = try? await config.features.share.additionalTextProvider?.getShareText(productIds: productIds)
                gallery.ui.activity.stop()

                let result = await vc.share(image: watermarker.watermark(image),
                                            additions: [attachment].compactMap { $0 })
                switch result {
                    case let .succeeded(activity):
                        tracker.track(.share(event: .succeeded(targetId: activity), pageId: page, productIds: productIds))
                    case let .canceled(activity):
                        tracker.track(.share(event: .canceled(targetId: activity), pageId: page, productIds: productIds))
                    case let .failed(activity, _):
                        tracker.track(.share(event: .failed(targetId: activity), pageId: page, productIds: productIds))
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
