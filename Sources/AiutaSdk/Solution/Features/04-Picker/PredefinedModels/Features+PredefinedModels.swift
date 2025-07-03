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
final class PredefinedModelsViewController: ViewController<PredefinedModelsView> {
    @injected private var subscription: Sdk.Core.Subscription
    @injected private var models: Sdk.Core.Models

    let onSelect = Signal<Aiuta.Image>()
    private var cache: [ImageLoader]?

    override func setup() {
        ui.navBar.onBack.subscribe(with: self) { [unowned self] in
            dismissAll()
        }

        ui.navBar.onClose.subscribe(with: self) { [unowned self] in
            dismissAll()
        }

        ui.categorySelector.onSelect.subscribe(with: self) { [unowned self] category in
            ui.preview.crossDissolveChanges = true
            ui.magnifier.images = models.predefinedModels.first(where: { $0.category == category })?.models
            ui.tryOnButton.animations.visibleTo(true)
        }

        ui.tryOnButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            guard let image = ui.magnifier.selected else { return }
            onSelect.fire(image)
        }

        models.didLoadModels.subscribePast(with: self) { [unowned self] in
            showPredefinedModels()
        }
    }

    private func showPredefinedModels() {
        let knownCategories = models.predefinedModels.filter { !$0.models.isEmpty }.map(\.category)
        if knownCategories.isEmpty {
            ui.showEmptyState()
        } else {
            ui.categorySelector.categories = knownCategories
        }

        Task {
            let breadcrumbs = Breadcrumbs()
            let imgs = models.predefinedModels.flatMap(\.models)
            cache = await imgs.concurrentCompactMap {
                try? await $0.prefetch(.thumbnails, breadcrumbs: breadcrumbs)
            }
        }
    }
}
