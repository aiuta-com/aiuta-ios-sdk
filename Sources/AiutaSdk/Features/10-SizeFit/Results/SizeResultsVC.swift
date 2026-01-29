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

@available(iOS 13.0.0, *)
final class SizeResultsVC: ViewController<SizeResultsUI> {
    @injected private var session: Sdk.Core.Session
    private var survey: Aiuta.FitSurvey?
    private var recommendation: Aiuta.SizeRecommendation?

    convenience init(survey: Aiuta.FitSurvey, recommendation: Aiuta.SizeRecommendation) {
        self.init()
        self.survey = survey
        self.recommendation = recommendation
    }

    override func setup() {
        ui.navBar.onClose.subscribe(with: self) { [unowned self] in
            dismissAll()
        }

        ui.acknowledge.onTouchUpInside.subscribe(with: self) { [unowned self] in
            dismissAll { [session, recommendation] in
                session.finish(recommendingSize: recommendation)
            }
        }

        ui.changeButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            dismiss()
        }

        ui.surveyDescription.text = survey?.description

        guard let recommendation, !recommendation.recommendedSizeName.isEmpty else {
            ui.title.view.isVisible = false
            ui.noResultDescription.view.isVisible = true
            ui.noResultIcon.view.isVisible = true
            ui.bestSize.view.isVisible = false
            ui.nextSize.view.isVisible = false
            return
        }

        ui.recommendedSize.text = recommendation.recommendedSizeName

        let cfg = Aiuta.SizeRecommendation.ConfidenceConfig()

        recommendation.sizes.forEach { size in
            let isRecommended = size.name == recommendation.recommendedSizeName
            let summary = size.measurements.fitSummary(isRecommended: isRecommended) ?? "-"
            let pct = recommendation.absoluteConfidencePercent(for: size, config: cfg)
            print(size.name, "\(pct)%", summary)
        }

        if let best = recommendation.recommendedSize {
            let summary = best.measurements.fitSummary(isRecommended: true) ?? ""
            let bestPct = max(30, recommendation.absoluteConfidencePercent(for: best, config: cfg))
            ui.bestSize.confidence = bestPct
            ui.bestSize.tittle.text = best.name
            ui.bestSize.summary.text = summary

            if let neighbor = recommendation.bestNeighborOfRecommended(config: cfg) {
                let summary = neighbor.measurements.fitSummary(isRecommended: false) ?? ""
                let nextPct = recommendation.absoluteConfidencePercent(for: neighbor, config: cfg)
                ui.nextSize.confidence = clamp(nextPct, min: 20, max: bestPct - 10)
                ui.nextSize.tittle.text = neighbor.name
                ui.nextSize.summary.text = summary
            } else {
                ui.nextSize.view.isVisible = false
            }
        } else {
            ui.bestSize.view.isVisible = false
            ui.nextSize.view.isVisible = false
        }
    }
}

@available(iOS 13.0.0, *)
extension SizeResultsVC: PageRepresentable {
    var page: Aiuta.Event.Page { .sizeFitResults }
    var isSafeToDismiss: Bool { true }
}
