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

    private var isConsentGiven: Bool {
        ui.scroll.consent.checkBox.isSelected
    }

    override func setup() {
        ui.navBar.onClose.subscribe(with: self) { [unowned self] in
            dismissAll()
        }

        ui.navBar.onBack.subscribe(with: self) { [unowned self] in
            if ui.scroll.isAtStart {
                dismissAll()
            } else {
                ui.scroll.scrollToPrev()
            }
        }

        ui.scroll.onSlide.subscribe(with: self) { [unowned self] _ in
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
            case 0: ui.navBar.title = "<b>Step 1/3</b> - How it works"
            case 1: ui.navBar.title = "<b>Step 2/3</b> - For best result"
            case 2: ui.navBar.title = "<b>Step 3/3</b> - Consent"
            default: ui.navBar.title = nil
        }
    }

    private func updateButton() {
        ui.button.text = ui.scroll.isAtEnd ? L.start : L.next
        let isEnabled = isConsentGiven || !ui.scroll.isAtEnd
        ui.button.view.isUserInteractionEnabled = isEnabled
        ui.button.view.isMaxOpaque = isEnabled
        ui.button.animations.transition(.transitionCrossDissolve, duration: .sixthOfSecond)
    }
}
