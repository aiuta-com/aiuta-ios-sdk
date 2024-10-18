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

extension OnBoardingView {
    final class StickyScroll: HScroll {
        let onSlide = Signal<Int>()

        let howItWorks = HowItWorksSlide()
        let bestResults = BestResultsSlide()
        let consent = ConsentSlide()

        var bottomInset: CGFloat = 0 {
            didSet { updateLayout() }
        }

        var slideIndex: Int {
            clamp(pageIndex - howItWorks.pages + 1, min: 0, max: 2)
        }

        var pageIndex: Int = -1 {
            didSet {
                guard oldValue != pageIndex else { return }
                onSlide.fire(pageIndex)
            }
        }

        var pageCount: Int {
            howItWorks.pages + 2
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
            howItWorks.interacitveImage.image.jump(to: page, from: oldPage)
            howItWorks.interacitveImage.navigator.forcedZoom = page
            howItWorks.animations.updateLayout { [self] in
                howItWorks.interacitveImage.navigator.forcedZoom = nil
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

            contentInset = .zero
            customLayout = true
            flexibleHeight = false

            didScroll.subscribe(with: self) { [unowned self] offset, _ in
                positionHowItWorks()
                pageIndex = clamp(Int(offset / layout.width + 0.5), min: 0, max: pageCount - 1)
            }

            subcontents.forEach { slide in
                slide.container.masksToBounds = true
            }
        }

        private func positionHowItWorks() {
            let offset = contentOffset.x
            let maxOffset = layout.width * CGFloat(howItWorks.pages - 1)
            howItWorks.offset = clamp(offset / maxOffset, min: 0, max: 1)

            howItWorks.layout.make { make in
                make.left = clamp(offset, min: 0, max: maxOffset)
            }
        }

        override func updateLayout() {
            howItWorks.layout.make { make in
                make.width = layout.width
                make.top = 0
                make.bottom = bottomInset
            }

            bestResults.layout.make { make in
                make.width = layout.width
                make.left = layout.width * CGFloat(howItWorks.pages)
                make.top = 0
                make.bottom = bottomInset
            }

            consent.layout.make { make in
                make.width = layout.width
                make.left = bestResults.layout.rightPin
                make.top = 0
                make.bottom = bottomInset
            }

            positionHowItWorks()

            contentSize = .init(width: consent.layout.rightPin, height: layout.height)
        }
    }
}
