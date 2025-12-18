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
    private var survey: Aiuta.FitSurvey?
    private var recommendataion: Aiuta.SizeRecommendation?

    convenience init(survey: Aiuta.FitSurvey, recommendataion: Aiuta.SizeRecommendation) {
        self.init()
        self.survey = survey
        self.recommendataion = recommendataion
    }

    override func setup() {
        ui.navBar.onClose.subscribe(with: self) { [unowned self] in
            dismissAll()
        }

        ui.acknowledge.onTouchUpInside.subscribe(with: self) { [unowned self] in
            dismissAll()
        }

        ui.changeButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            dismiss()
        }

        ui.surveyDescription.text = survey?.description

        guard let recommendataion, !recommendataion.recommendedSizeName.isEmpty else {
            ui.title.view.isVisible = false
            ui.noResultDescription.view.isVisible = true
            ui.noResultIcon.view.isVisible = true
            return
        }

        ui.recommendedSize.text = recommendataion.recommendedSizeName
    }
}

@available(iOS 13.0.0, *)
extension SizeResultsVC: PageRepresentable {
    var page: Aiuta.Event.Page { .sizeFitResults }
    var isSafeToDismiss: Bool { true }
}
