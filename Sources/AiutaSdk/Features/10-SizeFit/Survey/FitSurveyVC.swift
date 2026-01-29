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

        ui.navBar.onBack.subscribe(with: self) { [unowned self] in
            prevStep()
        }

        ui.findSize.onTouchUpInside.task(with: self) { [unowned self] in
            if !nextStep() {
                await findSize()
            }
        }

        ui.main.fields.forEach {
            $0.input.didChange.subscribe(with: self) { [unowned self] in
                updateSurvey()
            }
        }

        ui.main.gender.didChange.subscribe(with: self) { [unowned self] in
            updateSurvey()
        }

        ui.shape.didChange.subscribe(with: self) { [unowned self] in
            updateSurvey()
        }
        
        ui.bra.didChange.subscribe(with: self) { [unowned self] in
            updateSurvey()
        }

        animateKeyboardChanges = true
        survey = nil
        applyLastSurvey()
    }

    override func whenWillAppear() {
        guard ui.step != .main else { return }
        ui.step = .main
        ui.updateLayoutRecursive()
    }

    func applyLastSurvey() {
        guard let survey = sizeFit.lastSurvey else { return }
        ui.main.gender.value = survey.gender
        ui.main.age.intValue = survey.age
        ui.main.height.intValue = survey.height
        ui.main.weight.intValue = survey.weight
        ui.shape.bellyShape = survey.bellyShape
        ui.shape.hipShape = survey.hipShape
        ui.bra.braSize = survey.braSize
        ui.bra.braCup = survey.braCup
        updateSurvey()
    }

    func updateSurvey() {
        guard let age = ui.main.age.intValue,
              let height = ui.main.height.intValue,
              let weight = ui.main.weight.intValue,
              let gender = ui.main.gender.value else {
            survey = nil
            return
        }

        survey = .init(age: age, height: height, weight: weight, gender: gender,
                       hipShape: ui.shape.hipShape, bellyShape: ui.shape.bellyShape,
                       braSize: ui.bra.braSize, braCup: ui.bra.braCup)
    }

    func prevStep() {
        switch ui.step {
            case .main: break
            case .bra:
                ui.step = .shape
                ui.animations.updateLayout()
            case .shape:
                ui.step = .main
                ui.animations.updateLayout()
        }
    }

    func nextStep() -> Bool {
        switch ui.step {
            case .main:
                ui.step = .shape
                ui.animations.updateLayout()
                return true
            case .shape:
                guard ui.main.gender.value == .female else { return false }
                ui.step = .bra
                ui.animations.updateLayout()
                return true
            case .bra: return false
        }
    }

    func findSize() async {
        guard let survey, let product = session.products.first else { return }
        ui.isLoading = true

        do {
            let recommendation = try await sizeFit.recommendation(survey: survey, product: product)
            present(SizeResultsVC(survey: survey, recommendation: recommendation))
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
