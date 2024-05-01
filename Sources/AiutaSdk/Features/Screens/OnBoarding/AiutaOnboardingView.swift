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

final class AiutaOnboardingView: Plane {
    let onOverScroll = Signal<Void>()
    let onSlide = Signal<Int>()

    let blur = Blur { it, _ in
        it.style = .extraLight
    }

    let scrollView = StickyScroll()
    let swipeEdge = SwipeEdge()
    let navBar = AiutaNavBar { it, _ in
        it.isMinimal = true
    }

    let indicator = PageIndicator()

    let startButton = LabelButton { it, ds in
        it.font = ds.font.buttonBig
        it.color = ds.color.accent
        it.text = "Next"
    }

    private(set) var isFinal = false {
        didSet {
            guard oldValue != isFinal else { return }
            startButton.text = isFinal ? "Start" : "Next"
            startButton.animations.transition(.transitionCrossDissolve, duration: .quarterOfSecond)
        }
    }

    private var isOverScrolled = false {
        didSet {
            guard oldValue != isOverScrolled else { return }
            if isOverScrolled { onOverScroll.fire() }
        }
    }
    
    private var pageIndex: Int = -1 {
        didSet {
            guard oldValue != pageIndex else { return }
            onSlide.fire(pageIndex)
        }
    }

    override func setup() {
        scrollView.didScroll.subscribe(with: self) { [unowned self] offset, _ in
            isFinal = offset >= scrollView.view.horizontalOffsetForRight - layout.width / 2
            isOverScrolled = offset > scrollView.view.horizontalOffsetForRight + 80
            indicator.offset = offset / layout.width
            pageIndex = clamp(Int(offset / layout.width), min: 0, max: scrollView.interactiveSlide.pages)
        }
    }

    override func updateLayout() {
        blur.layout.make { make in
            make.size = layout.size
        }

        scrollView.layout.make { make in
            make.leftRight = 0
            make.top = navBar.layout.bottomPin
            make.bottom = 0
        }

        startButton.layout.make { make in
            make.leftRight = 16
            make.height = 50
            make.radius = 8
            make.bottom = layout.safe.insets.bottom + 12
        }

        indicator.layout.make { make in
            make.centerX = 0
            make.bottom = startButton.layout.topPin + 28
        }

        scrollView.interactiveSlide.layout.make { make in
            make.size = scrollView.layout.size
            make.height -= indicator.layout.topPin + 22
        }

        scrollView.finalSlide.layout.make { make in
            make.size = scrollView.layout.size
            make.height -= indicator.layout.topPin + 22
        }
    }
}

extension AiutaOnboardingView {
    final class StickyScroll: HScroll {
        let interactiveSlide = InteractiveSlide()
        let finalSlide = FinalSlide()

        func jump(to page: Int) {
            let oldPage = Int(contentOffset.x / layout.width)
            guard oldPage != page else { return }
            interactiveSlide.contents.image.jump(to: page, from: oldPage)
            interactiveSlide.contents.navigator.forcedZoom = page
            interactiveSlide.animations.updateLayout { [self] in
                interactiveSlide.contents.navigator.forcedZoom = nil
            }
            scroll(to: CGFloat(page) * layout.width, animated: false)
        }

        func scrollToNext() {
            let page = Int(contentOffset.x / layout.width)
            scroll(to: CGFloat(page + 1) * layout.width, animated: true)
        }

        override func setup() {
            view.isPagingEnabled = true
            view.decelerationRate = .fast

            contentInset = .zero
            customLayout = true
            flexibleHeight = false

            didScroll.subscribe(with: self) { [unowned self] _, _ in
                updateLayout()
            }
        }

        override func updateLayout() {
            let offset = contentOffset.x
            let maxOffset = layout.width * CGFloat(interactiveSlide.pages - 1)
            interactiveSlide.offset = clamp(offset / maxOffset, min: 0, max: 1)

            interactiveSlide.layout.make { make in
                make.left = clamp(offset, min: 0, max: maxOffset)
                make.top = 0
            }

            finalSlide.layout.make { make in
                make.top = 0
                make.left = layout.width * CGFloat(interactiveSlide.pages)
            }

            contentSize = .init(width: finalSlide.layout.rightPin, height: layout.height)
        }
    }
}

extension AiutaOnboardingView {
    final class InteractiveSlide: Plane {
        let pages: Int = 3

        var offset: CGFloat = 0 {
            didSet {
                guard oldValue != offset else { return }
                contents.navigator.offset = offset
                contents.image.offset = offset
                updateLayoutRecursive()
            }
        }

        let title = Label { it, ds in
            it.font = ds.font.boardingHeader
            it.text = "Try on before buying"
        }

        let description = Label { it, ds in
            it.font = ds.font.boardingText
            it.isMultiline = true
            it.alignment = .center
            it.text = "Just upload your photo\nand see how it looks"
        }

        final class Contents: Plane {
            let image = InteractiveImage()
            let navigator = InteractiveNavigator()

            override func updateLayout() {
                navigator.layout.make { make in
                    make.height = 312
                    make.width = 88
                    make.left = 0
                    make.centerY = 0
                }
                
                image.layout.make { make in
                    make.inset = 0
                    make.fit(.init(width: 284, height: 434))
                }
            }
        }

        let contents = Contents()

        override func updateLayout() {
            title.layout.make { make in
                make.top = 8
                make.centerX = 0
            }

            description.layout.make { make in
                make.top = title.layout.bottomPin + 18
                make.centerX = 0
            }

            contents.layout.make { make in
                make.leftRight = 20
                make.top = description.layout.bottomPin + 48
                make.bottom = 9
            }
        }
    }
}

extension AiutaOnboardingView {
    final class InteractiveImage: Plane {
        let image1 = Image { it, ds in
            it.isAutoSize = false
            it.contentMode = .scaleAspectFill
            it.image = ds.image.sdk(.aiutaOnBoard1l1)
        }

        let image2 = Image { it, ds in
            it.isAutoSize = false
            it.contentMode = .scaleAspectFill
            it.image = ds.image.sdk(.aiutaOnBoard1l2)
        }

        let image3 = Image { it, ds in
            it.isAutoSize = false
            it.contentMode = .scaleAspectFill
            it.image = ds.image.sdk(.aiutaOnBoard1l3)
        }

        var images: [Image] {
            findChildren()
        }

        var offset: CGFloat = 0
        var isLocked = false

        func jump(to newIndex: Int, from oldIndex: Int) {
            isLocked = true
            images.indexed.forEach { i, item in
                if i == 0 || (newIndex < oldIndex && i == newIndex) || i == oldIndex {
                    item.view.opacity = 1
                } else {
                    item.view.opacity = 0
                }
            }
            animations.animate(changes: { [self] in
                images.indexed.forEach { i, item in
                    if i == 0 || (newIndex > oldIndex && i == oldIndex) || i == newIndex {
                        item.view.opacity = 1
                    } else {
                        item.view.opacity = 0
                    }
                }
            }) { [self] in
                isLocked = false
            }
        }

        override func updateLayout() {
            layout.make { make in
                make.radius = 24
            }

            let peak = offset * CGFloat(images.count - 1)
            images.indexed.forEach { i, item in
                if !isLocked {
                    item.view.opacity = 1 - clamp(CGFloat(i) - peak, min: 0, max: 1)
                }
                item.layout.make { make in
                    make.size = layout.size
                }
            }
        }
    }
}

extension AiutaOnboardingView {
    final class InteractiveNavigator: Shadow {
        let item1 = NavigationItem { it, ds in
            it.image.image = ds.image.sdk(.aiutaOnBoard1s1)
        }

        let item2 = NavigationItem { it, ds in
            it.image.image = ds.image.sdk(.aiutaOnBoard1s2)
        }

        let item3 = NavigationItem { it, ds in
            it.image.image = ds.image.sdk(.aiutaOnBoard1s3)
        }

        var items: [NavigationItem] {
            findChildren()
        }

        var scroll: StickyScroll? {
            firstParentOfType()
        }

        var offset: CGFloat = 0
        var forcedZoom: Int?

        override func setup() {
            shadowColor = .black
            shadowOpacity = 0.12
            shadowRadius = 13.2
            shadowOffset = .init(width: 0, height: 2.55)

            items.indexed.forEach { i, item in
                item.onTouchUpInside.subscribe(with: self) { [unowned self] in
                    scroll?.jump(to: i)
                }
            }
        }

        override func updateLayout() {
            var itemTop: CGFloat = 0
            let peak = offset * CGFloat(items.count - 1)
            items.indexed.forEach { i, item in
                if let forcedZoom {
                    item.zoom = i == forcedZoom ? 1 : 0
                } else {
                    item.zoom = 1 - clamp(abs(CGFloat(i) - peak), min: 0, max: 1)
                }
                item.layout.make { make in
                    make.top = itemTop
                    make.centerX = 0
                }

                itemTop = item.layout.bottomPin + 8
            }
        }
    }
}

extension AiutaOnboardingView {
    final class NavigationItem: PlainButton {
        var zoom: CGFloat = 0

        let image = Image { it, _ in
            it.contentMode = .scaleAspectFit
            it.isAutoSize = false
        }

        override func setup() {
            view.backgroundColor = ds.color.item
        }

        override func updateLayout() {
            layout.make { make in
                make.width = 64 + zoom * 24 // 64 ... 88
                make.height = 88 + zoom * 32 // 88 ... 120
                make.radius = 9.6 + zoom * 3.6 // 9.6 ... 13.2
            }

            image.layout.make { make in
                make.inset = 2
            }
        }

        convenience init(_ builder: (_ it: NavigationItem, _ ds: DesignSystem) -> Void) {
            self.init()
            builder(self, ds)
        }
    }
}

extension AiutaOnboardingView {
    final class FinalSlide: Plane {
        let title = Label { it, ds in
            it.font = ds.font.boardingHeader
            it.text = "For best results"
        }

        let description = Label { it, ds in
            it.font = ds.font.boardingText
            it.isMultiline = true
            it.alignment = .center
            it.text = "Use a photo with good lighting,\nstand straight a plain background"
        }

        let image = Image { it, ds in
            it.image = ds.image.sdk(.aiutaOnBoard2)
        }

        override func updateLayout() {
            title.layout.make { make in
                make.top = 8
                make.centerX = 0
            }

            description.layout.make { make in
                make.top = title.layout.bottomPin + 18
                make.centerX = 0
            }

            image.layout.make { make in
                make.leftRight = 20
                make.top = description.layout.bottomPin + 48
                make.bottom = 9
                make.fit(image.image?.size)
            }
        }
    }
}

extension AiutaOnboardingView {
    final class PageIndicator: HScroll {
        final class Dot: Plane {
            let ground = Stroke { it, _ in
                it.color = 0xC7C7CCFF.uiColor
            }

            let highlight = Stroke { it, ds in
                it.color = ds.color.accent
            }

            var index: CGFloat = 0 {
                didSet {
                    view.isVisible = index >= 0 && index <= 3
                }
            }

            var distance: CGFloat = 0 {
                didSet {
                    guard oldValue != distance else { return }
                    highlight.view.opacity = clamp(1 - distance, min: 0, max: 1)
                    ground.view.opacity = clamp(3 - distance, min: 0, max: 1)
                    updateLayout()
                }
            }

            override func updateLayout() {
                layout.make { make in
                    if abs(distance) >= 1 {
                        make.width = 10
                    } else {
                        make.width = 10 + 16 * (1 - distance)
                    }
                    make.height = 4
                }

                ground.layout.make { make in
                    if abs(distance) > 1 {
                        make.circle = 4 - abs(distance - 1)
                    } else {
                        make.leftRight = 3
                        make.height = 4
                        make.radius = make.height / 2
                        if #available(iOS 13.0, *) {
                            make.curve = .circular
                        }
                    }
                    make.center = .zero
                }

                highlight.layout.make { make in
                    make.leftRight = 3
                    make.height = 4
                    make.radius = make.height / 2
                    if #available(iOS 13.0, *) {
                        make.curve = .circular
                    }
                }
            }
        }

        var offset: CGFloat = 0 {
            didSet {
                dots.forEach { dot in
                    dot.distance = abs(dot.index - offset)
                }
                contentOffset = .init(x: offset * 10, y: 0)
                update()
            }
        }

        var dots: [Dot] {
            findChildren()
        }

        override func setup() {
            view.isUserInteractionEnabled = false

            for i in 0 ... 10 {
                addContent(Dot()) { it, _ in
                    it.index = CGFloat(i) - 3
                }
            }

            offset = 0
        }

        override func updateLayout() {
            layout.make { make in
                make.width = 86
                make.height = 4
            }
        }
    }
}
