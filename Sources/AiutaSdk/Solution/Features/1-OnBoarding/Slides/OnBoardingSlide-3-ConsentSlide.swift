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

extension OnBoardingView.StickyScroll {
    final class ConsentSlide: Plane {
        let onConsentChange = Signal<Bool>()
        var onLinkTapped: Signal<String> {
            description.onLink
        }

        let title = Label { it, ds in
            it.font = ds.font.titleL
            it.color = ds.color.primary
            it.text = "Consent"
        }

        let description = TextView { it, ds in
            it.font = ds.font.regular
            it.color = ds.color.primary
            it.text = "In order to try on items digitally, you agree to allow Aiuta to process your photo. Your data will be processed according to the Aiuta <b><a href=\"https://aiuta.com/legal/privacy-policy.html\">Privacy Notice</a></b> and <b><a href=\"https://aiuta.com/legal/terms-of-service.html\">Terms of Use.</a></b>"
        }

        let checkBox = CheckBoxArea()

        override func setup() {
            checkBox.onTouchUpInside.subscribe(with: self) { [unowned self] in
                checkBox.isSelected.toggle()
                onConsentChange.fire(checkBox.isSelected)
            }
        }

        override func updateLayout() {
            title.layout.make { make in
                make.leftRight = 24
                make.top = 64
            }

            description.layout.make { make in
                make.leftRight = title.layout.left
                make.top = title.layout.bottomPin + 16
            }

            checkBox.layout.make { make in
                make.top = description.layout.bottomPin + 28
                make.leftRight = description.layout.left
            }
        }
    }

    final class CheckBoxArea: PlainButton {
        var isSelected: Bool {
            get { box.isSelected }
            set { box.isSelected = newValue }
        }

        let box = CheckBox()

        let label = Label { it, ds in
            it.isLineHeightMultipleEnabled = true
            it.isMultiline = true
            it.font = ds.font.regular
            it.color = ds.color.primary
            it.text = "I agree to allow Aiuta to process my photo"
        }

        override func updateLayout() {
            box.layout.make { make in
                make.left = 0
                make.top = 12
            }

            label.layout.make { make in
                make.top = box.layout.top
                make.left = box.layout.rightPin + 16
                make.right = 0
            }

            layout.make { make in
                make.height = label.layout.bottomPin + box.layout.top
            }
        }
    }

    final class CheckBox: Stroke {
        var isSelected = false {
            didSet {
                guard oldValue != isSelected else { return }
                color = isSelected ? ds.color.brand : .clear
                view.borderWidth = isSelected ? 0 : 2
                check.view.isVisible = isSelected
                animations.transition(.transitionCrossDissolve, duration: .sixthOfSecond)
            }
        }

        let check = Image { it, ds in
            it.tint = ds.color.onDark
            it.image = ds.image.icon24(.checkSmall)
            it.view.isVisible = false
        }

        override func setup() {
            view.borderColor = ds.color.darkGray
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
    }
}
