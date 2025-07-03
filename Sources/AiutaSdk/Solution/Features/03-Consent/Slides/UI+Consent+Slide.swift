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
    final class Slide: Plane {
        var onConsentChange = Signal<Void>()

        let onLinkTapped = Signal<String>()

        var isConsentGiven: Bool {
            !scroll.area.boxes.contains(where: { $0.consent.isRequired && !$0.isSelected })
        }

        var givenConsents: [String] {
            scroll.area.boxes.filter { $0.isSelected }.map { $0.consent.id }
        }

        private let scroll = Scroll()

        override func updateLayout() {
            scroll.layout.make { make in
                make.top = -layout.top
                make.bottom = -layout.bottom
                make.leftRight = 24
            }

            let isCompact = scroll.contentSize.height < view.bounds.height - 80 - layout.bottom

            scroll.contentInset = .init(top: layout.top + (isCompact ? 32 : 24),
                                        bottom: layout.bottom + 48)
        }

        override func setup() {
            scroll.description.onLink.subscribe(with: self) { [unowned self] link in
                onLinkTapped.fire(link)
            }

            scroll.footer.onLink.subscribe(with: self) { [unowned self] link in
                onLinkTapped.fire(link)
            }

            scroll.area.boxes.forEach { box in
                box.label.onLink.subscribe(with: self) { [unowned self] link in
                    onLinkTapped.fire(link)
                }

                box.onConsentChange.subscribe(with: self) { [unowned self] in
                    onConsentChange.fire()
                }
            }
        }
    }
}

extension Sdk.UI.Consent {
    final class Scroll: VScroll {
        let title = Label { it, ds in
            it.font = ds.fonts.titleL
            it.color = ds.colors.primary
            it.text = ds.strings.consentTitle
        }

        let description = TextView { it, ds in
            it.font = ds.fonts.regular
            it.color = ds.colors.primary
            it.text = ds.strings.consentDescriptionHtml
        }

        let area = Area()

        let footer = TextView { it, ds in
            it.font = ds.fonts.regular
            it.color = ds.colors.primary
            it.text = ds.strings.consentFooterHtml
        }

        override func setup() {
            itemSpace = 16
        }

        override func updateLayout() {
            view.isScrollEnabled = contentSize.height + contentInset.verticalInsetsSum > view.bounds.height
        }
    }
}
