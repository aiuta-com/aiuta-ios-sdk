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
import Resolver
import UIKit

@available(iOS 13.0.0, *)
final class AiutaTryOnResultViewController: ComponentController<AiutaTryOnView> {
    @injected private var model: AiutaSdkModel
    @injected private var watermarker: Watermarker
    @injected private var tracker: AnalyticTracker

    let skuBulletin = AiutaSkuBulletin()

    var generatedImages: [Aiuta.GeneratedImage] {
        ui.resultView.data?.items.compactMap { result in
            switch result {
                case let .output(generatedImage, _): return generatedImage
                default: return nil
            }
        } ?? []
    }

    override func setup() {
        model.onChangeResults.subscribe(with: self) { [unowned self] _, _ in
            updateResults()
        }

        model.onChangeSku.subscribePast(with: self) { [unowned self] _ in
            let moreToTryOn = model.moreToTryOn
            ui.resultView.moreToTryOn.data = nil
            ui.resultView.moreToTryOn.data = PartialDataProvider(moreToTryOn)
            ui.resultView.moreToTryOn.updateItems()
            ui.resultView.moreHeader.isVisible = !moreToTryOn.isEmpty
        }

        ui.resultView.moreToTryOn.onTapItem.subscribe(with: self) { [unowned self] cell in
            guard let sku = cell.data else { return }
            tracker.track(.results(.tapRelated(sku: sku)))
            skuBulletin.sku = sku
            showBulletin(skuBulletin)
        }

        ui.resultView.results.onRegisterItem.subscribe(with: self) { [unowned self] cell in
            cell.onTouchUpInside.subscribe(with: self) { [unowned self, weak cell] in
                guard case let .output(generatedImage, _) = cell?.data else { return }
                let images = generatedImages
                let index = images.firstIndex(where: { $0 == generatedImage }) ?? 0
                let gallery = AiutaGeneratedGalleryViewController(DataProvider(images), start: index)
                gallery.willShare.subscribe(with: self) { [unowned self] generatedImage, gallery in
                    let sku = findSku(for: generatedImage)
                    Task {
                        guard let image = try? await generatedImage.fetch() else { return }
                        tracker.track(.share(.start(origin: .resultsFullScreen, count: 1, text: sku?.additionalShareInfo)))
                        model.delegate?.aiuta(eventOccurred: .shareGeneratedImages(photosCount: 1))
                        let result = await gallery.share(image: watermarker.watermark(image),
                                                         additions: [sku?.additionalShareInfo].compactMap { $0 })
                        switch result {
                            case let .succeeded(activity):
                                tracker.track(.share(.success(origin: .resultsFullScreen, count: 1, activity: activity, text: sku?.additionalShareInfo)))
                            case let .canceled(activity):
                                tracker.track(.share(.cancelled(origin: .resultsFullScreen, count: 1, activity: activity)))
                            case let .failed(activity, error):
                                tracker.track(.share(.failed(origin: .resultsFullScreen, count: 1, activity: activity, error: error)))
                        }
                    }
                }
                present(gallery)
            }

            cell.shareButton.onTouchUpInside.subscribe(with: self) { [unowned self, weak cell] in
                guard case let .output(generatedImage, sku) = cell?.data else { return }
                Task {
                    guard let image = try? await generatedImage.fetch() else { return }
                    tracker.track(.share(.start(origin: .resultsScreen, count: 1, text: sku.additionalShareInfo)))
                    model.delegate?.aiuta(eventOccurred: .shareGeneratedImages(photosCount: 1))
                    let result = await share(image: watermarker.watermark(image),
                                             additions: [sku.additionalShareInfo].compactMap { $0 })
                    switch result {
                        case let .succeeded(activity):
                            tracker.track(.share(.success(origin: .resultsScreen, count: 1, activity: activity, text: sku.additionalShareInfo)))
                        case let .canceled(activity):
                            tracker.track(.share(.cancelled(origin: .resultsScreen, count: 1, activity: activity)))
                        case let .failed(activity, error):
                            tracker.track(.share(.failed(origin: .resultsScreen, count: 1, activity: activity, error: error)))
                    }
                }
            }
        }

        skuBulletin.primaryButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            guard let sku = skuBulletin.sku else { return }
            tracker.track(.results(.selectRelated(sku: sku)))
            skuBulletin.dismiss()
            model.tryOnSku = sku
        }

        skuBulletin.secondaryButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            guard let sku = skuBulletin.sku,
                  let delegate = model.delegate
            else { return }
            vc?.dismiss(animated: true) {
                delay(.moment) { delegate.aiuta(showSku: sku.skuId) }
            }
            tracker.track(.session(.finish(action: .showSkuInfo, origin: .moreToTry, sku: sku)))
        }

        ui.resultView.willShowContinuation.subscribe(with: self) { [unowned self] in
            tracker.track(.results(.showRelated))
        }

        ui.resultView.didNavigateToItem.subscribe(with: self) { [unowned self] image, sku, navigation in
            guard let sku = sku ?? model.tryOnSku, let index = generatedImages.firstIndex(of: image) else { return }
            tracker.track(.results(.view(sku: sku, index: index, navigation: navigation)))
        }
    }

    func updateResults() {
        ui.resultView.data = DataProvider(model.generationResults.reversed())
    }

    private func findSku(for generatedImage: Aiuta.GeneratedImage) -> Aiuta.SkuInfo? {
        let output = ui.resultView.data?.items.first(where: {
            switch $0 {
                case let .output(i, _): return i == generatedImage
                default: return false
            }
        })
        switch output {
            case let .output(_, sku): return sku
            default: return nil
        }
    }
}
