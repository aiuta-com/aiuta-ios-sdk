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
final class OnBoardingViewController: ViewController<OnBoardingView> {
    @injected private var consentModel: ConsentModel
    @injected private var sessionModel: SessionModel

    private var trackedPage: Aiuta.Event.Page?
    private var isConsentGiven: Bool {
        ui.scroll.consent.checkBox.isSelected
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

        ui.scroll.consent.onLinkTapped.subscribe(with: self) { [unowned self] url in
            openUrl(url)
        }

        ui.scroll.consent.onConsentChange.subscribe(with: self) { [unowned self] isGiven in
            consentModel.isConsentGiven = isGiven
            updateButton()
        }

        ui.button.onTouchUpInside.subscribe(with: self) { [unowned self] in
            if ui.scroll.isAtEnd {
                if isConsentGiven {
                    sessionModel.dataDelegate?.obtainUserConsent()
                    sessionModel.delegate?.aiuta(eventOccurred: .onboarding(event: .consentGiven))
                    sessionModel.delegate?.aiuta(eventOccurred: .onboarding(event: .onboardingFinished))
                    replace(with: TryOnViewController())
                }
            } else {
                ui.scroll.scrollToNext()
            }
        }
    }

    private func updateTitle() {
        guard ui.ds.config.appearance.extendedOnbordingNavBar else {
            ui.navBar.title = nil
            return
        }
        switch ui.scroll.slideIndex {
            case 0: ui.navBar.title = L.onboardingAppbarTryonPage
            case 1: ui.navBar.title = L.onboardingAppbarBestResultPage
            case 2: ui.navBar.title = L.onboardingAppbarConsentPage
            default: ui.navBar.title = nil
        }
    }

    private func updateButton() {
        ui.button.text = ui.scroll.isAtEnd ? L.onboardingButtonStart : L.onboardingButtonNext
        let isEnabled = isConsentGiven || !ui.scroll.isAtEnd
        ui.button.view.isUserInteractionEnabled = isEnabled
        ui.button.view.isMaxOpaque = isEnabled
        ui.button.animations.transition(.transitionCrossDissolve, duration: .sixthOfSecond)
    }

    private func trackPage() {
        guard page != trackedPage else { return }
        sessionModel.delegate?.aiuta(eventOccurred: .page(pageId: page))
        trackedPage = page
    }
}

@available(iOS 13.0.0, *)
extension OnBoardingViewController: PageRepresentable {
    var page: Aiuta.Event.Page {
        switch ui.scroll.slideIndex {
            case 0: return .howItWorks
            case 1: return .bestResults
            case 2: return .consent
            default: return .welcome
        }
    }

    var isSafeToDismiss: Bool { true }
}
