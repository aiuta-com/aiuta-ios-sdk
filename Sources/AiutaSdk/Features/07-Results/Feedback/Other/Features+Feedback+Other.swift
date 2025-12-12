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
final class FeedbackCommentViewController: ViewController<FeedbackCommentView> {
    @injected private var subscription: Sdk.Core.Subscription

    private let didFeedback = Signal<Void>()
    private var result: String?

    override func setup() {
        ui.input.becomeFirstResponder()

        ui.navBar.onClose.subscribe(with: self) { [unowned self] in
            dismiss(animated: true) { [self] in
                didFeedback.fire()
            }
        }

        ui.commitButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            result = ui.input.text
            dismiss(animated: true) { [self] in
                didFeedback.fire()
            }
        }
    }

    override func whenDidDisappear() {
        didFeedback.fire()
    }

    override func whenDidAppear() {
        ui.animations.updateLayout()
    }

    func getFeedback() async -> String? {
        await withCheckedContinuation { continuation in
            didFeedback.subscribeOnce(with: self) { [unowned self] in
                continuation.resume(returning: result)
            }
        }
    }
}
