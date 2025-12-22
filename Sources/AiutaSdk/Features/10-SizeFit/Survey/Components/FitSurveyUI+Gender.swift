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
        
        var value: Aiuta.SizeRecommendation.Gender? {
            didSet {
                guard value != oldValue else { return }
                let isMale = value == .male
                let isFemale = value == .female
                male.color = isMale ? ds.colors.onLight : ds.colors.neutral
                male.label.color = isMale ? ds.colors.onDark : ds.colors.primary
                female.color = isFemale ? ds.colors.onLight : ds.colors.neutral
                female.label.color = isFemale ? ds.colors.onDark : ds.colors.primary
                animations.transition(.transitionCrossDissolve, duration: .quarterOfSecond)
                didChange.fire()
            }
        }

        let male = LabelButton { it, ds in
            it.font = ds.fonts.regular
            it.text = "Male"
        }

        let female = LabelButton { it, ds in
            it.font = ds.fonts.regular
            it.text = "Female"
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
                make.height = 92
            }

            male.layout.make { make in
                make.left = 20
                make.right = layout.width / 2 + 6
                make.height = 52
                make.shape = ds.shapes.buttonL
                make.centerY = 0
            }

            female.layout.make { make in
                make.right = 20
                make.left = layout.width / 2 + 6
                make.height = 52
                make.shape = ds.shapes.buttonL
                make.centerY = 0
            }
        }
    }
}
