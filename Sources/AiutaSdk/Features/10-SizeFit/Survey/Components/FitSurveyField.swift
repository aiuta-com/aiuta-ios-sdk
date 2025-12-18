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
    final class Field: PlainButton {
        var intValue: Int? {
            get { Int(input.text.trimmingCharacters(in: .whitespacesAndNewlines)) }
            set {
                if let newValue {
                    input.text = "\(newValue)"
                } else {
                    input.text = ""
                }
            }
        }

        var input = TextInput { it, ds in
            it.font = ds.fonts.regular
            it.color = ds.colors.primary
            it.lengthLimit = 3
            it.view.keyboardType = .numberPad
            it.view.backgroundColor = .clear
            it.view.isScrollEnabled = false
            it.view.isUserInteractionEnabled = false
        }

        var hint = Label { it, ds in
            it.font = ds.fonts.regular
            it.color = ds.colors.secondary
            it.view.isUserInteractionEnabled = false
        }

        var measurment = Label { it, ds in
            it.font = ds.fonts.buttonS
            it.color = ds.colors.link
        }

        private func createToolbar() -> UIView {
            let toolbar = UIToolbar()

            let flex = UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil
            )

            let done = UIBarButtonItem(
                image: UIImage(systemName: "checkmark"),
                style: .done,
                target: self,
                action: #selector(doneTapped)
            )

            toolbar.items = [flex, done]

            if #available(iOS 26.0, *) {
                toolbar.translatesAutoresizingMaskIntoConstraints = false

                let container = UIView()
                container.addSubview(toolbar)

                NSLayoutConstraint.activate([
                    toolbar.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    toolbar.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    toolbar.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                    toolbar.topAnchor.constraint(equalTo: container.topAnchor),
                ])

                container.frame.size.height = 44 + 16
                return container
            } else {
                toolbar.sizeToFit()
                return toolbar
            }
        }

        @objc private func doneTapped() {
            input.view.isUserInteractionEnabled = false
            input.resignFirstResponder()
            animations.updateLayout()
        }

        func resign() {
            doneTapped()
        }

        private var parentScroll: VScroll? { firstParentOfType() }

        override func setup() {
            view.backgroundColor = ds.colors.neutral

            onTouchUpInside.subscribe(with: self) { [unowned self] in
                input.view.isUserInteractionEnabled = true
                input.becomeFirstResponder()
                parentScroll?.scroll(to: self)
            }

            input.view.inputAccessoryView = createToolbar()
        }

        override func updateLayout() {
            layout.make { make in
                make.leftRight = 20
                make.height = 68
                make.shape = ds.shapes.buttonL
            }

            hint.layout.make { make in
                make.left = 16
                if input.isFirstResponder || !input.text.isEmpty {
                    make.top = 14
                    make.scale = 0.75
                } else {
                    make.centerY = 0
                    make.scale = 1
                }
            }

            input.layout.make { make in
                make.leftRight = 10
                make.height = 20
                make.top = 26
            }

            measurment.layout.make { make in
                make.centerY = 0
                make.right = 16
            }
        }

        convenience init(_ builder: (_ it: Field, _ ds: DesignSystem) -> Void) {
            self.init()
            builder(self, ds)
        }
    }
}
