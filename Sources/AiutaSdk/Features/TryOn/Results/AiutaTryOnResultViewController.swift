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

import Resolver
import UIKit

@available(iOS 13.0.0, *)
final class AiutaTryOnResultViewController: ComponentController<AiutaTryOnView> {
    @Injected private var model: AiutaSdkModel

    let skuBulletin = AiutaSkuBulletin()

    var generatedImages: [Aiuta.GeneratedImage] {
        ui.resultView.data?.items.compactMap { result in
            switch result {
                case let .output(generatedImage): return generatedImage
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
            skuBulletin.sku = sku
            showBulletin(skuBulletin)
        }

        ui.resultView.results.onRegisterItem.subscribe(with: self) { [unowned self] cell in
            cell.onTouchUpInside.subscribe(with: self) { [unowned self, weak cell] in
                guard case let .output(generatedImage) = cell?.data else { return }
                let images = generatedImages
                let index = images.firstIndex(where: { $0 == generatedImage }) ?? 0
                present(AiutaGeneratedGalleryViewController(DataProvider(images), start: index))
            }

            cell.shareButton.onTouchUpInside.subscribe(with: self) { [unowned self, weak cell] in
                guard let image = cell?.generatedImage.image else { return }
                vc?.share(image: image)
            }
        }

        skuBulletin.primaryButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            guard let sku = skuBulletin.sku else { return }
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
        }
    }

    func updateResults() {
        ui.resultView.data = DataProvider(model.generationResults.reversed())
    }
}
