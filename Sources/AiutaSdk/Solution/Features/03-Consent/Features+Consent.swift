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

extension Sdk.Features {
    @available(iOS 13.0.0, *)
    final class Consent: ViewController<Sdk.UI.Consent> {
        @injected private var session: Sdk.Core.Session
        @injected private var consent: Sdk.Core.Consent
        @injected private var tracker: AnalyticTracker
        
        private let onConsentGiven = Signal<Bool>()

        override func setup() {
            ui.navBar.onClose.subscribe(with: self) { [unowned self] in
                dismissAll()
            }

            ui.navBar.onBack.subscribe(with: self) { [unowned self] in
                dismissAll()
            }

            ui.consent.onLinkTapped.subscribe(with: self) { [unowned self] url in
                openUrl(url)
            }

            ui.consent.onConsentChange.subscribe(with: self) { [unowned self] in
                updateButton()
            }

            ui.button.onTouchUpInside.task(with: self) { [unowned self] in
                if ui.consent.isConsentGiven {
                    tracker.track(.onboarding(event: .consentsGiven(consentIds: ui.consent.givenConsents),
                                              pageId: page, productIds: session.products.ids))
                    if onConsentGiven.observers.isEmpty {
                        replace(with: TryOn())
                    } else {
                        onConsentGiven.fire(true)
                        dismiss()
                    }
                    await consent.obtain(consentsIds: ui.consent.givenConsents)
                }
            }

            tracker.track(.page(pageId: page, productIds: session.products.ids))
            updateButton()
        }

        override func whenDidDisappear() {
            onConsentGiven.fire(false)
        }

        func consentGiven() async -> Bool {
            await withCheckedContinuation { continuation in
                onConsentGiven.subscribeOnce(with: self) { result in
                    continuation.resume(returning: result)
                }
            }
        }

        private func updateButton() {
            let isEnabled = ui.consent.isConsentGiven
            ui.button.view.isUserInteractionEnabled = isEnabled
            ui.button.view.isMaxOpaque = isEnabled
            ui.button.animations.transition(.transitionCrossDissolve, duration: .sixthOfSecond)
        }
    }
}

@available(iOS 13.0.0, *)
extension Sdk.Features.Consent: PageRepresentable {
    var page: Aiuta.Event.Page { .consent }
    var isSafeToDismiss: Bool { true }
}
