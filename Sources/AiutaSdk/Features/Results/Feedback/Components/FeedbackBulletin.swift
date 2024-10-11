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

final class FeedbackBulletin: ResultBulletin<String?> {
    override var defaultResult: String? { nil }

    var feedback: Aiuta.SubscriptionDetails.Feedback? {
        didSet {
            removeAllContents()
            guard let feedback else { return }

            mainOptions = []
            plainOption = nil

            title.text = L[feedback.title]
            addContent(title)

            feedback.mainOptions?.forEach { option in
                guard let text = L[option], !text.isEmpty else { return }

                let option = LabelButton { it, ds in
                    it.font = ds.font.chips
                    it.label.color = ds.color.secondary
                    it.color = ds.color.neutral
                    it.text = text
                    it.view.borderColor = ds.color.primary
                    it.onTouchUpInside.subscribe(with: self) { [unowned self] in
                        setOption(text)
                    }
                }

                mainOptions.append(option)
                addContent(option)
            }

            if let plain = L[feedback.plaintextOption], !plain.isEmpty {
                plainOption = LabelButton { it, ds in
                    it.font = ds.font.chips
                    it.label.color = ds.color.secondary
                    it.color = ds.color.neutral
                    it.text = plain
                    it.view.borderColor = ds.color.primary
                    it.onTouchUpInside.subscribe(with: self) { [unowned self] in
                        setOption("")
                    }
                }

                addContent(plainOption!)
            }

            addContent(skipButton)
            addContent(commitButton)
            commitButton.view.isVisible = false
        }
    }

    private var mainOptions = [LabelButton]()
    private var plainOption: LabelButton?

    private let title = Label { it, ds in
        it.font = ds.font.titleL
        it.color = ds.color.primary
        it.isMultiline = true
        it.alignment = .center
    }

    private let skipButton = LabelButton { it, ds in
        it.font = ds.font.chips
        it.label.color = ds.color.secondary
        it.text = L.skip
    }

    private let commitButton = LabelButton { it, ds in
        it.color = ds.color.brand
        it.font = ds.font.button
        it.label.color = ds.color.onDark
        it.text = L.send
    }

    private var currentOption: String?

    private func setOption(_ text: String) {
        if text == currentOption {
            currentOption = nil
        } else {
            currentOption = text
        }

        commitButton.animations.visibleTo(currentOption.isSomeAndNotEmpty)

        mainOptions.forEach { button in
            let isSelected = button.text == currentOption
            button.color = isSelected ? .clear : ds.color.neutral
            button.label.color = isSelected ? ds.color.primary : ds.color.secondary
            button.view.borderWidth = isSelected ? 2 : 0
            button.animations.transition(.transitionCrossDissolve, duration: .quarterOfSecond)
        }

        if text.isEmpty { returnResult(text) }
    }

    override func setup() {
        maxWidth = 600
        strokeWidth = ds.dimensions.grabberWidth
        strokeOffset = ds.dimensions.grabberOffset
        cornerRadius = ds.dimensions.bottomSheetRadius
        view.backgroundColor = ds.color.ground

        skipButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            returnResult(nil)
        }

        commitButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
            returnResult(currentOption)
        }
    }

    override func updateLayout() {
        var top: CGFloat = 20

        title.layout.make { make in
            make.top = top
            make.leftRight = 20
        }

        top = title.layout.bottomPin + 32

        mainOptions.forEach { button in
            button.layout.make { make in
                make.top = top
                make.centerX = 0
                make.height = 40
                make.radius = ds.dimensions.buttonSmallRadius
            }

            top = button.layout.bottomPin + 12
        }

        if let plainOption {
            plainOption.layout.make { make in
                make.top = top
                make.centerX = 0
                make.height = 40
                make.radius = ds.dimensions.buttonSmallRadius
            }

            top = plainOption.layout.bottomPin + 35
        }

        skipButton.layout.make { make in
            make.top = top
            make.centerX = 0
            make.height = 50
        }

        commitButton.layout.make { make in
            make.top = top
            make.leftRight = 16
            make.height = 50
            make.radius = ds.dimensions.buttonLargeRadius
        }

        top = skipButton.layout.bottomPin + 12

        layout.make { make in
            make.height = top
        }
    }
}
