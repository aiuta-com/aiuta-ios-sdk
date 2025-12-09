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
final class FeedbackViewController: ComponentController<ResultPage> {
    @injected private var subscription: Sdk.Core.Subscription
    @injected private var tracker: AnalyticTracker
    @injected private var session: Sdk.Core.Session
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

@available(iOS 13.0.0, *)
private extension FeedbackViewController {
    func isFeedbackNeeded(_ sessionResult: Sdk.Core.TryOnResult) -> Bool {
        guard ds.features.tryOn.askForUserFeedbackOnResults else { return false }
        return !FeedbackViewController.feedbackedImages.contains(sessionResult.image.url)
    }

    func like(_ sessionResult: Sdk.Core.TryOnResult, _ cell: ResultPage?) {
        let generatedImage = sessionResult.image
        FeedbackViewController.feedbackedImages.append(generatedImage.url)
        haptic(notification: .success)
        gratiture(cell)
        tracker.track(.feedback(event: .positive, pageId: .results, productIds: sessionResult.products.ids))
    }

    func dislike(_ sessionResult: Sdk.Core.TryOnResult, _ cell: ResultPage?) {
        let generatedImage = sessionResult.image
        FeedbackViewController.feedbackedImages.append(generatedImage.url)
        Task { await dislike(sessionResult.products, cell) }
    }

    @available(iOS 13.0.0, *)
    func dislike(_ products: Aiuta.Products, _ cell: ResultPage?) async {
        var result: FeedbackResult?

        if hasDislikeOptions {
            result = await showBulletin(FeedbackBulletin())
        }

        if result?.text.isEmpty == true || (!hasDislikeOptions && hasPlaintextOption) {
            let commmentVc = FeedbackCommentViewController()
            var feedWall: FeedWall?
            if UIViewController.isStackingAllowed {
                vc?.popover(commmentVc)
            } else {
                feedWall = FeedWall()
                feedWall?.modalPresentationStyle = .overFullScreen
                vc?.present(feedWall!, animated: false)
                feedWall!.popover(commmentVc)
            }
            let text = await commmentVc.getFeedback()
            feedWall?.dismiss(animated: false)
            if let text, !text.isEmpty { result = (text: text, index: nil) }
            else { result = nil }
        }

        if let result, !result.text.isEmpty {
            let text = String(result.text.prefix(1200))
            tracker.track(.feedback(event: .negative(option: result.index ?? ds.strings.feedbackOptions.count, text: text), pageId: .results, productIds: products.ids))
        } else {
            tracker.track(.feedback(event: .negative(option: -1, text: nil), pageId: .results, productIds: products.ids))
        }

        gratiture(cell)
    }

    var hasDislikeOptions: Bool {
        ds.strings.feedbackOptions.first(where: { !$0.isEmpty }).isSome
    }

    var hasPlaintextOption: Bool {
        ds.features.tryOn.askForOtherFeedbackOnResults
    }

    func gratiture(_ cell: ResultPage?) {
        guard let cell else { return }

        let gratitudeView = FeedbackGratitudeView { it, _ in
            it.title.text = ds.strings.feedbackGratitudeText
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

private final class FeedWall: UIViewController {
    override func loadView() { view = UIView() }
}
