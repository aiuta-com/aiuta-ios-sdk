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


import UIKit

@available(iOS 13.0.0, *)
final class AiutaTryOnResultViewController: ComponentController<AiutaTryOnView> {
    var moreToTryOn: [Aiuta.SkuInfo]?
    let skuBulletin = AiutaSkuBulletin()

    var results = [AiutaTryOnResult]() {
        didSet {
            ui.resultView.data = DataProvider(results)
        }
    }

    var generatedImages = [Aiuta.GeneratedImage]()

    override func setup() {
        ui.resultView.moreToTryOn.onTapItem.subscribe(with: self) { [unowned self] cell in
            guard let sku = cell.data else { return }
            skuBulletin.sku = sku
            showBulletin(skuBulletin)
        }

        ui.resultView.results.onRegisterItem.subscribe(with: self) { [unowned self] cell in
            cell.onTouchUpInside.subscribe(with: self) { [unowned self, weak cell] in
                guard case let .generatedImage(generatedImage) = cell?.data else { return }
                let index = generatedImages.firstIndex(where: { $0 == generatedImage }) ?? 0
                present(AiutaGeneratedGalleryViewController(DataProvider(generatedImages), start: index))
            }

            cell.shareButton.onTouchUpInside.subscribe(with: self) { [unowned self, weak cell] in
                guard let image = cell?.generatedImage.image else { return }
                vc?.share(image: image)
            }
        }

        skuBulletin.primaryButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            guard let sku = skuBulletin.sku else { return }
            (vc as? AiutaTryOnViewController)?.changeSku(sku)
            skuBulletin.dismiss()
        }

        skuBulletin.secondaryButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            guard let sku = skuBulletin.sku,
                  let delegate = (vc as? AiutaTryOnViewController)?.session?.delegate
            else { return }
            vc?.dismiss()
            delay(.thirdOfSecond) { [delegate] in
                delegate.aiuta(showSku: sku.skuId)
            }
        }
    }

    func showResult(_ operation: Aiuta.TryOnOperation, sku: Aiuta.SkuInfo?, original: Aiuta.UploadedImage?) {
        let offset = ui.resultView.offset(fromIndex: results.count)

        generatedImages.append(contentsOf: operation.generatedImages)
        results.append(contentsOf: operation.generatedImages.map { .generatedImage($0) })
        if let sku { results.append(.sku(sku)) }

        if let moreToTryOn {
            ui.resultView.moreToTryOn.data = DataProvider(moreToTryOn)
            ui.resultView.moreHeader.isVisible = !moreToTryOn.isEmpty
        } else {
            ui.resultView.moreHeader.isVisible = false
        }

        guard let url = operation.generatedImages.first?.imageUrl else { return }
        ui.sample.view.loadImage(url) { [weak self] in
            self?.ui.resultView.scrollView.contentOffset = .init(x: 0, y: offset)
            self?.ui.mode = .result
        }
    }
}
