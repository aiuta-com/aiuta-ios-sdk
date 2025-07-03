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

extension Sdk.UI.Consent {
    final class Check: Stroke {
        var isSelected = false {
            didSet {
                guard oldValue != isSelected else { return }
                updateColor()
                view.borderWidth = isSelected ? 0 : 2
                check.view.isVisible = isSelected
                animations.transition(.transitionCrossDissolve, duration: .sixthOfSecond)
            }
        }

        var isEnabled: Bool = true {
            didSet {
                guard oldValue != isEnabled else { return }
                updateColor()
            }
        }

        let check = Image { it, ds in
            it.tint = ds.colors.onDark
            it.image = ds.icons.check20
            it.view.isVisible = false
        }

        override func setup() {
            view.borderColor = ds.colors.outline
            view.borderWidth = 2
        }

        override func updateLayout() {
            layout.make { make in
                make.square = 20
                make.radius = 2
            }

            check.layout.make { make in
                make.square = 20
            }
        }

        private func updateColor() {
            if isEnabled {
                color = isSelected ? ds.colors.brand : .clear
            } else {
                color = ds.colors.outline
            }
        }
    }
}
