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

final class AiutaFeedbackCommentViewController: ViewController<AiutaFeedbackCommentView> {
    @injected private var subscription: AiutaSubscription

    private let didFeedback = Signal<String?>()

    override func setup() {
        ui.input.becomeFirstResponder()
        ui.title.text = L[subscription.feedback?.plaintextTitle]

        ui.close.onTouchUpInside.subscribe(with: self) { [unowned self] in
            didFeedback.fire(nil)
            dismiss()
        }

        ui.commitButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            didFeedback.fire(ui.input.text)
            dismiss()
        }
    }

    override func whenDidDisappear() {
        didFeedback.fire(nil)
    }

    override func whenDidAppear() {
        ui.animations.updateLayout()
    }

    func getFeedback() async -> String? {
        await withCheckedContinuation { continuation in
            didFeedback.subscribeOnce(with: self) { feedback in
                continuation.resume(returning: feedback)
            }
        }
    }
}

extension AiutaFeedbackCommentViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .popover
    }
}
