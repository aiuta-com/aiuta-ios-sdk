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

extension Sdk.UI.Onboarding {
    final class StickyScroll: HScroll {
        let onSlide = Signal<Int>()

        var howItWorks: HowItWorksSlide?
        var bestResults: BestResultsSlide?
        var consent: Sdk.UI.Consent.Slide?

        var topInset: CGFloat = 0 {
            didSet { updateLayout() }
        }

        var bottomInset: CGFloat = 0 {
            didSet { updateLayout() }
        }

        var slideIndex: Int {
            guard let howItWorks else { return pageIndex }
            return clamp(pageIndex - howItWorks.pages + 1, min: 0, max: 2)
        }

        var pageIndex: Int = -1 {
            didSet {
                guard oldValue != pageIndex else { return }
                onSlide.fire(pageIndex)
            }
        }

        var pageCount: Int {
            var count = howItWorks?.pages ?? 0
            if bestResults.isSome { count += 1 }
            if consent.isSome { count += 1 }
            return count
        }

        var isAtStart: Bool {
            pageIndex == 0
        }

        var isAtEnd: Bool {
            pageIndex == pageCount - 1
        }

        func jump(to page: Int) {
            let oldPage = Int(contentOffset.x / layout.width)
            guard oldPage != page else { return }
            howItWorks?.interacitveImage.image.jump(to: page, from: oldPage)
            howItWorks?.interacitveImage.navigator.forcedZoom = page
            howItWorks?.animations.updateLayout { [self] in
                howItWorks?.interacitveImage.navigator.forcedZoom = nil
            }
            scroll(to: CGFloat(page) * layout.width, animated: false)
        }

        func scrollToNext() {
            let page = Int(contentOffset.x / layout.width)
            scroll(to: CGFloat(page + 1) * layout.width, animated: true)
        }

        func scrollToPrev() {
            let page = Int(contentOffset.x / layout.width)
            scroll(to: CGFloat(page - 1) * layout.width, animated: true)
        }

        override func setup() {
            view.isPagingEnabled = true
            view.decelerationRate = .fast

            if ds.features.onboarding.isEnabled {
                howItWorks = addContent(HowItWorksSlide())
            }

            if ds.features.onboarding.hasBestResults {
                bestResults = addContent(BestResultsSlide())
            }

            if ds.features.consent.isOnboarding {
                consent = addContent(Sdk.UI.Consent.Slide())
            }

            contentInset = .zero
            customLayout = true
            flexibleHeight = false

            didScroll.subscribe(with: self) { [unowned self] offset, _ in
                positionHowItWorks()
                pageIndex = clamp(Int(offset / layout.width + 0.5), min: 0, max: pageCount - 1)
            }
        }

        private func positionHowItWorks() {
            guard let howItWorks else { return }
            let offset = contentOffset.x
            let maxOffset = layout.width * CGFloat(howItWorks.pages - 1)
            howItWorks.offset = clamp(offset / maxOffset, min: 0, max: 1)

            howItWorks.layout.make { make in
                make.left = clamp(offset, min: 0, max: maxOffset)
            }
        }

        override func updateLayout() {
            howItWorks?.layout.make { make in
                make.width = layout.width
                make.top = topInset
                make.bottom = bottomInset
            }

            var right = layout.width * CGFloat(howItWorks?.pages ?? 0)

            bestResults?.layout.make { make in
                make.width = layout.width
                make.left = right
                make.top = topInset
                make.bottom = bottomInset

                right += layout.width
            }

            consent?.layout.make { make in
                make.width = layout.width
                make.left = right
                make.top = topInset
                make.bottom = bottomInset
                right += layout.width
            }

            positionHowItWorks()
            contentSize = .init(width: right, height: layout.height)
        }
    }
}
