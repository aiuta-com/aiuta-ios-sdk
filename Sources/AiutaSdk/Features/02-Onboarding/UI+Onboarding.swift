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

extension Sdk.UI {
    final class Onboarding: Plane {
        let scroll = StickyScroll()

        private let blurTop = Blur { it, ds in
            it.style = ds.colors.scheme.safeBlurStyle
            it.backgroundColor = ds.colors.background.withAlphaComponent(0.75)
        }

        private let blurBottom = Blur { it, ds in
            it.style = ds.colors.scheme.safeBlurStyle
            it.backgroundColor = ds.colors.background.withAlphaComponent(0.45)
        }

        let navBar = NavBar { it, ds in
            if ds.styles.preferCloseButtonOnTheRight {
                it.style = .backTitleClose
            } else {
                it.style = .backTitleAction
            }
        }

        let legal = TextView { it, ds in
            it.font = ds.fonts.product
            it.alignment = .center
            it.color = ds.colors.secondary
            it.text = ds.strings.consentHtml
            it.view.isVisible = ds.features.consent.isEmbedded
        }

        let button = LabelButton { it, ds in
            it.font = ds.fonts.buttonM
            it.color = ds.colors.brand
            it.label.color = ds.colors.onDark
            it.text = ds.strings.onboardingButtonNext
            it.view.minOpacity = 0.4
        }

        override func updateLayout() {
            blurTop.layout.make { make in
                make.frame = navBar.layout.frame
            }

            scroll.layout.make { make in
                make.inset = 0
            }

            legal.layout.make { make in
                make.leftRight = 16
                make.bottom = layout.safe.insets.bottom + 16
            }

            button.layout.make { make in
                make.leftRight = 16
                make.height = 48
                make.shape = ds.shapes.buttonM
                if legal.view.isVisible {
                    make.bottom = legal.layout.topPin + 24
                } else {
                    make.bottom = layout.safe.insets.bottom + 16
                }
            }

            blurBottom.layout.make { make in
                make.leftRight = 0
                make.top = button.layout.top - 8
                make.bottom = 0
            }

            scroll.topInset = navBar.layout.bottomPin
            scroll.bottomInset = button.layout.topPin
        }
    }
}
