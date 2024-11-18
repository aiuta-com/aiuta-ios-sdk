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

extension TryOnView {
    final class FitDisclaimerBulletin: PlainBulletin {
        let label = Label { it, ds in
            it.font = ds.font.regular
            it.color = ds.color.primary
            it.isMultiline = true
            it.text = L.fitDisclaimerBody
        }

        let button = LabelButton { it, ds in
            it.font = ds.font.button
            it.label.color = ds.color.primary
            it.view.borderColor = ds.color.neutral2
            it.view.borderWidth = 1
            it.text = L.close
        }

        override func setup() {
            maxWidth = 600
            strokeWidth = ds.dimensions.grabberWidth
            strokeOffset = ds.dimensions.grabberOffset
            cornerRadius = ds.dimensions.bottomSheetRadius
            view.backgroundColor = ds.color.ground

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
                make.radius = ds.dimensions.buttonLargeRadius
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
