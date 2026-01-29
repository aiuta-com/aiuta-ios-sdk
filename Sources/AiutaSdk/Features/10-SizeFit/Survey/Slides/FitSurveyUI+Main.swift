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
    final class Main: Scroll {
        @scrollable
        var header = Header { it, _ in
            it.text = "Find your size"
        }

        @scrollable
        var gender = GenderSelector()

        @scrollable
        var age = Field { it, _ in
            it.hint.text = "Age"
        }

        @scrollable
        var height = Field { it, _ in
            it.hint.text = "Height"
            it.measurment.text = "CM"
        }

        @scrollable
        var weight = Field { it, _ in
            it.hint.text = "Weight"
            it.measurment.text = "KG"
        }

        var fields: [Field] { scrollView.findChildren() }
        var insets: UIEdgeInsets = .zero

        @notification(UIResponder.keyboardWillHideNotification)
        private var keyboardWillHide: Signal<Notification>

        func hideKeyboard() {
            fields.forEach { $0.resign() }
            animations.animate { [self] in
                updateLayoutRecursive()
            }
        }

        override func setup() {
            scrollView.itemSpace = 12
            scrollView.flexibleWidth = false

            scrollView.gestures.onTap(cancelsTouchesInView: false, with: self) { [unowned self] tap in
                guard tap.state == .ended else { return }
                let point = tap.location(in: scrollView.view)

                for v in fields {
                    let p = scrollView.view.convert(point, to: v.view)
                    if v.view.bounds.contains(p) { return }
                }

                hideKeyboard()
            }

            keyboardWillHide.subscribe(with: self) { [unowned self] _ in
                scrollView.scrollToTop()
            }
        }

        override func updateLayout() {
            layout.make { make in
                make.size = layout.boundary.size
            }

            scrollView.keepOffset {
                scrollView.contentInset = .init(top: insets.top,
                                                bottom: max(insets.bottom, layout.keyboard.height) + 16)
            }
        }
    }
}
