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
        var onConsentChange: Signal<Bool> {
            scroll.checkBox.onConsentChange
        }

        let onLinkTapped = Signal<String>()

        var isConsentGiven: Bool {
            scroll.checkBox.isSelected
        }

        var supplementaryConsents: [Aiuta.Consent] {
            scroll.supplementaryBoxes.map { $0.consent }
        }

        private let scroll = ConsentSlideScroll()

        override func updateLayout() {
            scroll.layout.make { make in
                make.top = 0
                make.bottom = 8
                make.leftRight = 24
            }
        }

        override func setup() {
            scroll.description.onLink.subscribe(with: self) { [unowned self] link in
                onLinkTapped.fire(link)
            }

            scroll.footer.onLink.subscribe(with: self) { [unowned self] link in
                onLinkTapped.fire(link)
            }
        }
    }

    final class ConsentSlideScroll: VScroll {
        let title = Label { it, ds in
            it.font = ds.font.titleL
            it.color = ds.color.primary
            it.text = L.onboardingPageConsentTopic
        }

        let description = TextView { it, ds in
            it.font = ds.font.regular
            it.color = ds.color.primary
            it.text = L.onboardingPageConsentBody
        }

        let checkBox = CheckBoxArea { it, _ in
            it.text = L.onboardingPageConsentAgreePoint
        }

        var supplementaryBoxes: [CheckBoxArea] = []

        let footer = TextView { it, ds in
            it.font = ds.font.regular
            it.color = ds.color.primary
            it.text = L.onboardingPageConsentFooter
        }

        override func setup() {
            contentInset = .init(top: L.onboardingPageConsentSupplementaryPoints.isEmpty ? 32 : 24, bottom: 48)
            itemSpace = 16

            L.onboardingPageConsentSupplementaryPoints.forEach { text in
                let box = CheckBoxArea { it, _ in
                    it.text = text
                }
                addContent(box)
                supplementaryBoxes.append(box)
            }

            footer.removeFromParent()
            addContent(footer)
        }

        override func updateLayout() {
            view.isScrollEnabled = contentSize.height + contentInset.verticalInsetsSum > view.bounds.height
        }
    }

    final class CheckBoxArea: PlainButton {
        let onConsentChange = Signal<Bool>()

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
        }

        var text: String = "" {
            didSet { label.text = text }
        }

        var consent: Aiuta.Consent {
            .init(consentText: text, isObtained: isSelected)
        }

        override func setup() {
            onTouchUpInside.subscribe(with: self) { [unowned self] in
                isSelected.toggle()
                onConsentChange.fire(isSelected)
            }
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

        convenience init(_ builder: (_ it: CheckBoxArea, _ ds: DesignSystem) -> Void) {
            self.init()
            builder(self, ds)
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
            it.image = ds.image.icon20(.check)
            it.view.isVisible = false
        }

        override func setup() {
            view.borderColor = ds.color.neutral3
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
