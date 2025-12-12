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

extension Sdk.UI.Consent {
    final class Box: PlainButton {
        let onConsentChange = Signal<Void>()

        var consent: Aiuta.Consent = .init(id: "", type: .explicit(isRequired: false), html: "") {
            didSet {
                label.text = consent.html
                switch consent.type {
                    case let .implicit(hasCheckBox):
                        check.isSelected = true
                        check.isEnabled = false
                        check.view.isVisible = hasCheckBox
                    case .explicit:
                        check.isSelected = false
                        check.isEnabled = true
                        check.view.isVisible = true
                }
            }
        }

        var isSelected: Bool {
            get { check.isSelected }
            set { check.isSelected = newValue }
        }

        var inset: CGFloat = 0 {
            didSet { updateLayout() }
        }

        let check = Check()

        let label = TextView { it, ds in
            it.isLineHeightMultipleEnabled = true
            it.font = ds.styles.drawBordersAroundConsents ? ds.fonts.buttonS : ds.fonts.regular
            it.color = ds.colors.primary
        }

        var text: String = "" {
            didSet { label.text = text }
        }

        override func setup() {
            onTouchUpInside.subscribe(with: self) { [unowned self] in
                guard check.isEnabled else { return }
                isSelected.toggle()
                onConsentChange.fire()
            }
        }

        override func updateLayout() {
            check.layout.make { make in
                make.left = inset
                make.top = 12
            }

            label.layout.make { make in
                if let lh = label.font?.lineHeightMultiple, lh > 1 {
                    make.top = check.layout.top - 1.5 * lh
                } else {
                    make.top = check.layout.top
                }
                if check.view.isVisible {
                    make.left = check.layout.rightPin + 16
                } else {
                    make.left = inset
                }
                make.right = inset
            }

            layout.make { make in
                make.height = max(label.layout.bottomPin, check.layout.bottomPin) + check.layout.top
            }
        }

        convenience init(_ builder: (_ it: Box, _ ds: DesignSystem) -> Void) {
            self.init()
            builder(self, ds)
        }
    }
}
