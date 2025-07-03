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

final class PredefinedCategorySelector: Plane {
    let onSelect = Signal<String>()

    var categories: [String]? {
        didSet {
            placeholders.forEach { $0.removeFromParent() }
            placeholders = []

            Zip(categories, buttons).longest.forEach { category, button in
                guard let category else {
                    button?.removeFromParent()
                    return
                }

                if let button {
                    button.category = category
                } else {
                    addContent(CategoryButton({ it, ds in
                        it.labelInsets = .init(horizontal: 12, vertical: 20)
                        it.font = ds.fonts.buttonS
                        it.label.color = ds.colors.primary
                        it.category = category

                        it.onTouchUpInside.subscribe(with: self) { [unowned self, weak it] in
                            guard let category = it?.category else { return }
                            selected = category
                        }
                    }))
                }
            }

            updateLayout()
            let preferred = ds.features.imagePicker.preferredPredefinedModelsCategoryId
            selected = categories?.first(where: { $0 == preferred }) ?? categories?.first
            animations.transition(.transitionCrossDissolve, duration: .quarterOfSecond)
        }
    }

    private(set) var selected: String? {
        didSet {
            guard oldValue != selected, let selected else { return }
            if oldValue.isSome { animations.updateLayout() }
            onSelect.fire(selected)
        }
    }

    private var buttons: [CategoryButton] {
        findChildren()
    }

    private let stroke = Stroke { it, ds in
        it.color = ds.colors.brand
    }

    private var placeholders: [Stroke] = []

    override func setup() {
        for _ in 0 ... 1 {
            let placeholder = Stroke { it, ds in
                it.color = ds.colors.neutral
            }
            placeholders.append(placeholder)
            addContent(placeholder)
        }
    }

    override func updateLayout() {
        var left: CGFloat = 0
        var hasStroke: Bool = false

        placeholders.forEach { stroke in
            stroke.layout.make { make in
                make.width = 50
                make.height = 15
                make.centerY = 0
                make.left = left
                make.radius = 4
            }
            left = stroke.layout.rightPin + 6
        }
        left = max(0, left - 6)

        buttons.forEach { button in
            button.layout.make { make in
                make.left = left
                make.centerY = 0
            }
            left = button.layout.rightPin + 10

            if button.category == selected {
                hasStroke = true
                stroke.layout.make { make in
                    make.width = button.layout.width - 10
                    make.centerX = button.layout.centerX
                    make.height = 4
                    make.radius = 2
                }
            }
        }

        layout.make { make in
            make.width = max(0, left - 10)
            make.height = 35
            make.centerX = 0
        }

        if !hasStroke {
            stroke.layout.make { make in
                make.width = 0
                make.centerX = 0
                make.height = 4
                make.radius = 2
            }
        }

        stroke.layout.make { make in
            make.bottom = 0
        }
    }
}

extension PredefinedCategorySelector {
    final class CategoryButton: LabelButton {
        var category: String? {
            didSet {
                guard let category else {
                    text = nil
                    return
                }
                text = ds.strings.predefinedModelsCategories[category] ?? category.firstCapitalized
            }
        }

        convenience init(_ builder: (_ it: CategoryButton, _ ds: DesignSystem) -> Void) {
            self.init()
            builder(self, ds)
        }
    }
}
