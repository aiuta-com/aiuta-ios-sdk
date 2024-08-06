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

final class AiutaFeedbackViewController: ComponentController<AiutaTryOnResultCell.ScrollRecycler> {
    @injected private var subscription: AiutaSubscription
    @injected private var tracker: AnalyticTracker
    private var feedbackedImages = [String]()

    override func setup() {
        ui.onUpdateItem.subscribe(with: self) { [unowned self] cell in
            guard let result = cell.data else { return }
            cell.hasFeedback = isFeedbackNeeded(result)
        }

        ui.onRegisterItem.subscribe(with: self) { [unowned self] cell in
            cell.feedback.like.onTouchUpInside.subscribe(with: self) { [unowned self, weak cell] in
                guard let result = cell?.data else { return }
                like(result, cell)
            }

            cell.feedback.dislike.onTouchUpInside.subscribe(with: self) { [unowned self, weak cell] in
                guard let result = cell?.data else { return }
                dislike(result, cell)
            }
        }
    }
}

private extension AiutaFeedbackViewController {
    func isFeedbackNeeded(_ sessionResult: Aiuta.SessionResult) -> Bool {
        guard subscription.shouldDisplayFeedback else { return false }
        switch sessionResult {
            case let .output(generatedImage, _):
                return !feedbackedImages.contains(generatedImage.imageUrl)
            default: return false
        }
    }

    func like(_ sessionResult: Aiuta.SessionResult, _ cell: AiutaTryOnResultCell?) {
        switch sessionResult {
            case let .output(generatedImage, sku):
                feedbackedImages.append(generatedImage.imageUrl)
                tracker.track(.feedback(.like(sku: sku)))
                haptic(notification: .success)
                gratiture(cell)
            default: return
        }
    }

    func dislike(_ sessionResult: Aiuta.SessionResult, _ cell: AiutaTryOnResultCell?) {
        switch sessionResult {
            case let .output(generatedImage, sku):
                feedbackedImages.append(generatedImage.imageUrl)
                tracker.track(.feedback(.dislike(sku: sku)))
                if #available(iOS 13.0, *) {
                    Task { await dislike(sku, cell) }
                } else {
                    gratiture(cell)
                }
            default: return
        }
    }

    @available(iOS 13.0.0, *)
    func dislike(_ sku: Aiuta.SkuInfo, _ cell: AiutaTryOnResultCell?) async {
        var result: String?

        if hasDislikeOptions {
            let feedbackBulletin = AiutaFeedbackBulletin()
            feedbackBulletin.feedback = subscription.feedback
            result = await showBulletin(feedbackBulletin)
        }

        if result?.isEmpty == true || (!hasDislikeOptions && hasPlaintextOption) {
            let commmentVc = AiutaFeedbackCommentViewController()
            vc?.popover(commmentVc, attachedTo: cell)
            result = await commmentVc.getFeedback()
        }

        if let result, !result.isEmpty {
            tracker.track(.feedback(.comment(sku: sku, text: String(result.prefix(1200)))))
        } else {
            tracker.track(.feedback(.comment(sku: sku, text: nil)))
        }

        gratiture(cell)
    }

    var hasDislikeOptions: Bool {
        subscription.feedback?.mainOptions?.compactMap { L[$0] }.isEmpty == false
    }

    var hasPlaintextOption: Bool {
        L[subscription.feedback?.plaintextTitle].isSomeAndNotEmpty
    }

    func gratiture(_ cell: AiutaTryOnResultCell?) {
        guard let cell else { return }

        let gratitudeView = AiutaFeedbackGratitudeView { it, _ in
            it.title.text = L[subscription.feedback?.gratitudeMessage]
            it.view.isVisible = false
        }

        cell.addContent(gratitudeView)

        gratitudeView.animations.visibleTo(true)
        cell.feedback.animations.visibleTo(false, hideTime: .thirdOfSecond) { [weak cell] in
            cell?.hasFeedback = false
        }

        delay(.twoSeconds) { [gratitudeView] in
            gratitudeView.animations.visibleTo(false, hideTime: .thirdOfSecond) { [gratitudeView] in
                gratitudeView.removeFromParent()
            }
        }
    }
}
