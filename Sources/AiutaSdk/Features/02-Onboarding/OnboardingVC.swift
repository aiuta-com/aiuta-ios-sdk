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
import UIKit

extension Sdk.Features {
    @available(iOS 13.0.0, *)
    final class Onboarding: ViewController<Sdk.UI.Onboarding> {
        @injected private var onboarding: Sdk.Core.Onboarding
        @injected private var consent: Sdk.Core.Consent
        @injected private var session: Sdk.Core.Session
        @injected private var tracker: AnalyticTracker

        private var trackedPage: Aiuta.Event.Page?
        private var isConsentGiven: Bool {
            ui.scroll.consent?.isConsentGiven ?? true
        }

        override func setup() {
            ui.navBar.onClose.subscribe(with: self) { [unowned self] in
                dismissAll()
            }

            ui.navBar.onBack.subscribe(with: self) { [unowned self] in
                if ui.scroll.isAtStart {
                    if backstackController.isSome { dismiss() }
                    else { dismissAll() }
                } else {
                    ui.scroll.scrollToPrev()
                }
            }

            ui.scroll.onSlide.subscribe(with: self) { [unowned self] _ in
                trackPage()
                dispatch(.mainAsync) { [self] in
                    updateTitle()
                    updateButton()
                }
            }

            ui.legal.onLink.subscribe(with: self) { [unowned self] url in
                openUrl(url)
            }

            ui.scroll.consent?.onLinkTapped.subscribe(with: self) { [unowned self] url in
                openUrl(url)
            }

            ui.scroll.consent?.onConsentChange.subscribe(with: self) { [unowned self] in
                updateButton()
            }

            ui.button.onTouchUpInside.task(with: self) { [unowned self] in
                if ui.scroll.isAtEnd {
                    if isConsentGiven {
                        let consentIds = ui.scroll.consent?.givenConsents

                        if let consentIds {
                            tracker.track(.onboarding(event: .consentsGiven(consentIds: consentIds),
                                                      pageId: page, productIds: session.products.ids))
                        }
                        tracker.track(.onboarding(event: .onboardingFinished, pageId: page, productIds: session.products.ids))

                        replace(with: TryOn())

                        if let consentIds { await consent.obtain(consentsIds: consentIds) }
                        await onboarding.complete()
                    }
                } else {
                    ui.scroll.scrollToNext()
                }
            }
        }

        private func updateTitle() {
            switch ui.scroll.slideIndex {
                case 0:
                    ui.navBar.title = ds.features.onboarding.isEnabled
                        ? ds.strings.onboardingHowItWorksPageTitle
                        : ds.strings.consentPageTitle
                case 1:
                    ui.navBar.title = ds.features.onboarding.hasBestResults
                        ? ds.strings.onboardingBestResultsPageTitle
                        : ds.strings.consentPageTitle
                case 2:
                    ui.navBar.title = ds.strings.consentPageTitle
                default:
                    ui.navBar.title = nil
            }
        }

        private func updateButton() {
            if ui.scroll.isAtEnd {
                if ds.features.consent.isOnboarding {
                    ui.button.text = ds.strings.consentButtonAccept
                } else {
                    ui.button.text = ds.strings.onboardingButtonStart
                }
            } else {
                ui.button.text = ds.strings.onboardingButtonNext
            }
            let isEnabled = isConsentGiven || !ui.scroll.isAtEnd
            ui.button.view.isUserInteractionEnabled = isEnabled
            ui.button.view.isMaxOpaque = isEnabled
            ui.button.animations.transition(.transitionCrossDissolve, duration: .sixthOfSecond)
        }

        private func trackPage() {
            guard page != trackedPage else { return }
            tracker.track(.page(pageId: page, productIds: session.products.ids))
            trackedPage = page
        }
    }
}

@available(iOS 13.0.0, *)
extension Sdk.Features.Onboarding: PageRepresentable {
    var page: Aiuta.Event.Page {
        switch ui.scroll.slideIndex {
            case 0: return ds.features.onboarding.isEnabled ? .howItWorks : .consent
            case 1: return ds.features.onboarding.hasBestResults ? .bestResults : .consent
            case 2: return .consent
            default: return .welcome
        }
    }

    var isSafeToDismiss: Bool { true }
}
