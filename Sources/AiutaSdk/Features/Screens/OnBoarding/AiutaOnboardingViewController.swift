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
import Hero
import UIKit

final class AiutaOnboardingViewController: ViewController<AiutaOnboardingView> {
    @injected private var tracker: AnalyticTracker
    @injected private var model: AiutaSdkModel
    private var forwardVc: UIViewController?

    convenience init(forward vc: UIViewController) {
        self.init()
        forwardVc = vc
    }

    override func prepare() {
        hero.isEnabled = true
        hero.modalAnimationType = .selectBy(presenting: .push(direction: .left),
                                            dismissing: .pull(direction: .right))
    }

    override func setup() {
        ui.navBar.onDismiss.subscribe(with: self) { [unowned self] in
            dismiss()
        }

        ui.startButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            if ui.isFinal {
                forward()
            } else {
                ui.scrollView.scrollToNext()
            }
        }

        ui.onSlide.subscribe(with: self) { [unowned self] index in
            tracker.track(.onBoarding(.next(index: index)))
        }

        ui.onOverScroll.subscribe(with: self) { [unowned self] in
            forward()
        }

        enableInteractiveDismiss(withTarget: ui.swipeEdge)

        tracker.track(.onBoarding(.start))
    }

    private func forward() {
        guard let forwardVc else { return }
        tracker.track(.onBoarding(.finish))
        model.delegate?.aiuta(eventOccurred: .onBoardingCompleted)
        forwardVc.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .left),
                                                      dismissing: .pull(direction: .right))
        replace(with: forwardVc)
    }
}

@available(iOS 13.0.0, *)
extension AiutaOnboardingViewController: UIPopoverPresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return true
    }
}
