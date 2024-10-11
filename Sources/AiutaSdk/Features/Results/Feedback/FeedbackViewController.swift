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

final class FeedbackViewController: ComponentController<ResultPage> {
    @injected private var subscription: AiutaSubscription
    @injected private var tracker: AnalyticTracker
    private static var feedbackedImages = [String]()

    override func setup() {
        ui.onUpdate.subscribe(with: self) { [unowned self] in
            guard let result = ui.data else { return }
            ui.hasFeedback = isFeedbackNeeded(result)
        }

        ui.feedback.like.onTouchUpInside.subscribe(with: self) { [unowned self] in
            guard let result = ui.data else { return }
            like(result, ui)
        }

        ui.feedback.dislike.onTouchUpInside.subscribe(with: self) { [unowned self] in
            guard let result = ui.data else { return }
            dislike(result, ui)
        }
    }
}

private extension FeedbackViewController {
    func isFeedbackNeeded(_ sessionResult: TryOnResult) -> Bool {
        guard subscription.shouldDisplayFeedback else { return false }
        return !FeedbackViewController.feedbackedImages.contains(sessionResult.image.imageUrl)
    }

    func like(_ sessionResult: TryOnResult, _ cell: ResultPage?) {
        let generatedImage = sessionResult.image
        let sku = sessionResult.sku
        FeedbackViewController.feedbackedImages.append(generatedImage.imageUrl)
        tracker.track(.feedback(.like(sku: sku)))
        haptic(notification: .success)
        gratiture(cell)
    }

    func dislike(_ sessionResult: TryOnResult, _ cell: ResultPage?) {
        let generatedImage = sessionResult.image
        let sku = sessionResult.sku
        FeedbackViewController.feedbackedImages.append(generatedImage.imageUrl)
        tracker.track(.feedback(.dislike(sku: sku)))
        if #available(iOS 13.0, *) {
            Task { await dislike(sku, cell) }
        } else {
            gratiture(cell)
        }
    }

    @available(iOS 13.0.0, *)
    func dislike(_ sku: Aiuta.SkuInfo, _ cell: ResultPage?) async {
        var result: String?

        if hasDislikeOptions {
            let feedbackBulletin = FeedbackBulletin()
            feedbackBulletin.feedback = subscription.feedback
            result = await showBulletin(feedbackBulletin)
        }

        if result?.isEmpty == true || (!hasDislikeOptions && hasPlaintextOption) {
            let commmentVc = FeedbackCommentViewController()
            vc?.popover(commmentVc)
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

    func gratiture(_ cell: ResultPage?) {
        guard let cell else { return }

        let gratitudeView = FeedbackGratitudeView { it, _ in
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
