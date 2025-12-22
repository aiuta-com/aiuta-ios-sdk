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
final class FitSurveyVC: ViewController<FitSurveyUI> {
    @injected private var sizeFit: Sdk.Core.SizeFit
    @injected private var session: Sdk.Core.Session

    private var survey: Aiuta.FitSurvey? {
        didSet {
            ui.findSize.view.isUserInteractionEnabled = survey.isSome
            ui.findSize.animations.opacityTo(survey.isSome ? 1 : 0.3)
        }
    }

    override func setup() {
        ui.navBar.onClose.subscribe(with: self) { [unowned self] in
            dismissAll()
        }

        ui.findSize.onTouchUpInside.task(with: self) { [unowned self] in
            await findSize()
        }

        ui.fields.forEach {
            $0.input.didChange.subscribe(with: self) { [unowned self] in
                trySurvey()
            }
        }

        ui.gender.didChange.subscribe(with: self) { [unowned self] in
            trySurvey()
        }

        animateKeyboardChanges = true
        survey = nil
        applyLastSurvey()
    }

    func applyLastSurvey() {
        guard let survey = sizeFit.lastSurvey else { return }
        ui.gender.value = survey.gender
        ui.age.intValue = survey.age
        ui.height.intValue = survey.height
        ui.weight.intValue = survey.weight
        trySurvey()
    }

    func trySurvey() {
        guard let age = ui.age.intValue,
              let height = ui.height.intValue,
              let weight = ui.weight.intValue,
              let gender = ui.gender.value else {
            survey = nil
            return
        }

        survey = .init(age: age, height: height, weight: weight, gender: gender)
    }

    func findSize() async {
        guard let survey, let product = session.products.first else { return }
        ui.isLoading = true

        do {
            let recommendation = try await sizeFit.recommendation(survey: survey, product: product)
            present(SizeResultsVC(survey: survey, recommendataion: recommendation))
        } catch {
            trace(error)
            ui.errorSnackbar.isVisible = true
        }

        ui.isLoading = false
    }
}

@available(iOS 13.0.0, *)
extension FitSurveyVC: PageRepresentable {
    var page: Aiuta.Event.Page { .sizeFitSurvey }
    var isSafeToDismiss: Bool {
        !ui.layout.keyboard.isVisible
    }
}
