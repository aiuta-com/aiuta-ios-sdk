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
    final class Area: Plane {
        var boxes = [Box]()

        override func setup() {
            let hasBorders = ds.styles.drawBordersAroundConsents

            if hasBorders {
                view.borderColor = ds.colors.border
                view.borderWidth = 1
            }

            ds.features.consent.consents.forEach { consent in
                if hasBorders, !boxes.isEmpty {
                    addContent(Stroke { it, ds in
                        it.color = ds.colors.border
                        it.fixedHeight = 1
                    })
                }

                let box = Box { it, _ in
                    it.consent = consent
                    it.inset = hasBorders ? 16 : 0
                }
                addContent(box)
                boxes.append(box)
            }
        }

        override func updateLayout() {
            let spacing: CGFloat = 4
            let hasBorders = ds.styles.drawBordersAroundConsents
            var height: CGFloat = hasBorders ? spacing : 0

            subcontents.forEach { sub in
                sub.layout.make { make in
                    make.leftRight = 0
                    make.top = height
                }

                height = sub.layout.bottomPin + spacing
            }

            if !hasBorders {
                height = max(0, height - spacing)
            }

            layout.make { make in
                make.height = height
                make.shape = ds.shapes.onboardingImageL
            }
        }
    }
}
