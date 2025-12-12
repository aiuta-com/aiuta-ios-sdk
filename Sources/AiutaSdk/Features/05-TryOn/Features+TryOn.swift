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

import AiutaCore
@_spi(Aiuta) import AiutaKit
import Kingfisher
import Resolver
import StoreKit
import UIKit

extension Sdk.Features {
    @available(iOS 13.0.0, *)
    final class TryOn: ViewController<Sdk.UI.TryOn> {
        @injected private var history: Sdk.Core.History
        @injected private var session: Sdk.Core.Session
        @injected private var wishlist: Sdk.Core.Wishlist
        @injected private var consent: Sdk.Core.Consent
        @injected private var tracker: AnalyticTracker
        
        var selector: PhotoSelectorController?
        var bulletin: ProductBulletinController?

        override func setup() {
            selector = addComponent(PhotoSelectorController(ui))
            bulletin = addComponent(ProductBulletinController(ui.productBulletin))

            ui.navBar.onClose.subscribe(with: self) { [unowned self] in
                dismissAll()
            }

            ui.navBar.onAction.subscribe(with: self) { [unowned self] in
                popoverOrCover(HistoryViewController())
            }

            ui.emptyState.uploadButton.onTouchUpInside.task(with: self) { [unowned self] in
                await checkConsentAndChoosePhoto(canSelectPredefinedModel: false)
            }

            ui.emptyState.chooseModelButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
                selector?.selectPredefinedModel()
            }

            ui.photoState.changeButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
                selector?.choosePhoto()
            }

            selector?.didPick.subscribe(with: self) { [unowned self] source in
                replace(with: ProcessingViewController(source, origin: .selectedPhoto))
            }

            ui.photoState.tryOnBar.tryOnButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
                guard let source = ui.photoState.lastImage.source else {
                    selector?.choosePhoto()
                    return
                }
                replace(with: ProcessingViewController(source, origin: .tryOnButton))
            }

            ui.photoState.tryOnBar.productButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
                bulletin?.show(product: ui.photoState.tryOnBar.products?.first)
            }
            
            ui.photoState.tryOnBar.thumbnailsBar.onSelectProduct.subscribe(with: self) { [unowned self] product in
                bulletin?.show(product: product)
            }

            history.uploaded.onUpdate.subscribe(with: self) { [unowned self] in
                updateUploads(animated: true)
            }

            history.generated.onUpdate.subscribe(with: self) { [unowned self] in
                ui.navBar.isActionAvailable = history.hasGenerations
            }

            updateUploads()
            ui.photoState.tryOnBar.products = session.products
            ui.navBar.isActionAvailable = history.hasGenerations

            tracker.track(.page(pageId: page, productIds: session.products.ids))
        }

        private func checkConsentAndChoosePhoto(canSelectPredefinedModel: Bool = true) async {
            guard await consent.isRequiredOnImagePicker else {
                selector?.choosePhoto(canSelectPredefinedModel: canSelectPredefinedModel)
                return
            }
            let feature = Sdk.Features.Consent()
            popoverOrCover(feature)
            guard await feature.consentGiven() else {
                trace("Consent not given, cannot choose photo")
                return
            }
            await asleep(.quarterOfSecond)
            selector?.choosePhoto(canSelectPredefinedModel: canSelectPredefinedModel)
        }

        private func updateUploads(animated: Bool = false) {
            let source = history.uploaded.items.first
            ui.photoState.lastImage.source = source
            ui.emptyState.view.isVisible = source.isNil
            ui.photoState.view.isVisible = source.isSome
            if animated {
                ui.animations.transition(.transitionCrossDissolve, duration: .quarterOfSecond)
            }
        }
    }
}

@available(iOS 13.0.0, *)
extension Sdk.Features.TryOn: PageRepresentable {
    var page: Aiuta.Event.Page { .imagePicker }
    var isSafeToDismiss: Bool { true }
}
