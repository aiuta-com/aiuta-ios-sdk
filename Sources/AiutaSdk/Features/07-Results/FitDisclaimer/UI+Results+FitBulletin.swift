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

extension Sdk.UI.TryOn {
    final class FitDisclaimerBulletin: PlainBulletin {
        let label = Label { it, ds in
            it.font = ds.fonts.regular
            it.color = ds.colors.primary
            it.isMultiline = true
            it.text = ds.strings.fitDisclaimerDescription
        }

        let button = LabelButton { it, ds in
            it.font = ds.fonts.buttonM
            it.label.color = ds.colors.primary
            it.view.borderColor = ds.colors.border
            it.view.borderWidth = 1
            it.text = ds.strings.fitDisclaimerCloseButton
        }

        override func setup() {
            maxWidth = 600
            strokeWidth = ds.shapes.grabberWidth
            strokeOffset = ds.shapes.grabberOffset
            cornerRadius = ds.shapes.bottomSheet.radius
            view.backgroundColor = ds.colors.background

            button.onTouchUpInside.subscribe(with: self) { [unowned self] in
                dismiss()
            }
        }

        override func updateLayout() {
            label.layout.make { make in
                make.leftRight = 16
                make.top = 18
            }

            button.layout.make { make in
                make.leftRight = 16
                make.height = 50
                make.top = label.layout.bottomPin + 32
                make.shape = ds.shapes.buttonM
            }

            layout.make { make in
                make.height = button.layout.bottomPin + 16
            }
        }

        convenience init(_ builder: (_ it: FitDisclaimerBulletin, _ ds: DesignSystem) -> Void) {
            self.init()
            builder(self, ds)
        }
    }
}
