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

extension FitSurveyUI {
    final class GenderSelector: Plane {
        let didChange = Signal<Void>()

        var value: Aiuta.FitSurvey.Gender? {
            didSet {
                guard value != oldValue else { return }
                male.isSelected = value == .male
                female.isSelected = value == .female
                didChange.fire()
            }
        }

        let male = GenderButton { it, ds in
            it.label.text = "Male"
            it.icon.image = ds.icons.male20
        }

        let female = GenderButton { it, ds in
            it.label.text = "Female"
            it.icon.image = ds.icons.female20
        }

        override func setup() {
            value = .female

            male.onTouchUpInside.subscribe(with: self) { [unowned self] in
                value = .male
            }

            female.onTouchUpInside.subscribe(with: self) { [unowned self] in
                value = .female
            }
        }

        override func updateLayout() {
            layout.make { make in
                make.leftRight = 0
                make.height = 108
            }

            male.layout.make { make in
                make.left = 20
                make.right = layout.width / 2 + 6
                make.height = 68
                make.shape = ds.shapes.buttonL
                make.centerY = 0
            }

            female.layout.make { make in
                make.right = 20
                make.left = layout.width / 2 + 6
                make.height = male.layout.height
                make.shape = ds.shapes.buttonL
                make.centerY = 0
            }
        }
    }

    final class GenderButton: PlainButton {
        var isSelected = false {
            didSet {
                guard isSelected != oldValue else { return }
                updateSelected()
            }
        }

        private let labelWithIcon = LabelWithIcon()

        var label: Label { labelWithIcon.label }
        var icon: Image { labelWithIcon.icon }

        override func setup() {
            updateSelected()
            icon.tint = ds.colors.primary
            label.color = ds.colors.primary
            labelWithIcon.spacing = 10
        }

        override func updateLayout() {
            labelWithIcon.layout.make { make in
                make.center = .zero
            }
        }

        func updateSelected() {
            view.borderWidth = isSelected ? 2 : 1
            view.borderColor = isSelected ? ds.colors.primary : ds.colors.border
            animations.transition(.transitionCrossDissolve, duration: .quarterOfSecond)
        }

        convenience init(_ builder: (_ it: GenderButton, _ ds: DesignSystem) -> Void) {
            self.init()
            builder(self, ds)
        }
    }
}
