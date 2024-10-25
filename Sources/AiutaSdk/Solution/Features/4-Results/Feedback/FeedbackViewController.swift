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
    @injected private var subscription: SubscriptionModel
    @injected private var tracker: AnalyticTracker
    @injected private var session: SessionModel
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
        guard ds.config.behavior.asksForUserFeedbackOnResults else { return false }
        return !FeedbackViewController.feedbackedImages.contains(sessionResult.image.url)
    }

    func like(_ sessionResult: TryOnResult, _ cell: ResultPage?) {
        let generatedImage = sessionResult.image
        let sku = sessionResult.sku
        FeedbackViewController.feedbackedImages.append(generatedImage.url)
        tracker.track(.feedback(.like(sku: sku)))
        haptic(notification: .success)
        gratiture(cell)
        session.delegate?.aiuta(eventOccurred: .feedback(event: .positive))
    }

    func dislike(_ sessionResult: TryOnResult, _ cell: ResultPage?) {
        let generatedImage = sessionResult.image
        let sku = sessionResult.sku
        FeedbackViewController.feedbackedImages.append(generatedImage.url)
        tracker.track(.feedback(.dislike(sku: sku)))
        if #available(iOS 13.0, *) {
            Task { await dislike(sku, cell) }
        } else {
            gratiture(cell)
            session.delegate?.aiuta(eventOccurred: .feedback(event: .negative(option: nil, text: nil)))
        }
    }

    @available(iOS 13.0.0, *)
    func dislike(_ sku: Aiuta.SkuInfo, _ cell: ResultPage?) async {
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
            tracker.track(.feedback(.comment(sku: sku, text: text)))
            session.delegate?.aiuta(eventOccurred: .feedback(event: .negative(option: result.index, text: text)))
        } else {
            tracker.track(.feedback(.comment(sku: sku, text: nil)))
            session.delegate?.aiuta(eventOccurred: .feedback(event: .negative(option: nil, text: nil)))
        }

        gratiture(cell)
    }

    var hasDislikeOptions: Bool {
        L.feedbackSheetOptions.first(where: { !$0.isEmpty }).isSome
    }

    var hasPlaintextOption: Bool {
        !L.feedbackSheetExtraOption.isEmpty
    }

    func gratiture(_ cell: ResultPage?) {
        guard let cell else { return }

        let gratitudeView = FeedbackGratitudeView { it, _ in
            it.title.text = L.feedbackSheetGratitude
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
