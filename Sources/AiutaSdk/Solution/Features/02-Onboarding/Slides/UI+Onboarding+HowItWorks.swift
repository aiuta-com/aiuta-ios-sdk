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
    final class HowItWorksSlide: Plane {
        let pages: Int = 3

        var offset: CGFloat = 0 {
            didSet {
                guard oldValue != offset else { return }
                interacitveImage.navigator.offset = offset
                interacitveImage.image.offset = offset
                updateLayoutRecursive()
            }
        }

        let title = Label { it, ds in
            it.minScale = 0.75
            it.font = ds.fonts.titleL
            it.color = ds.colors.primary
            it.text = ds.strings.onboardingHowItWorksTitle
        }

        let description = Label { it, ds in
            it.isHtml = true
            it.isMultiline = true
            it.font = ds.fonts.regular
            it.color = ds.colors.primary
            it.text = ds.strings.onboardingHowItWorksDescription
        }

        let interacitveImage = InteractiveImageWithNavigation()

        override func updateLayout() {
            description.layout.make { make in
                make.left = 24
                make.right = 54
                make.bottom = 56
            }

            title.layout.make { make in
                make.bottom = description.layout.topPin + 16
                make.leftRight = 24
            }

            interacitveImage.layout.make { make in
                make.leftRight = 0
                make.top = 30
                make.bottom = title.layout.topPin + 68
            }
        }
    }

    // MARK: - Interactive image with navigation

    final class InteractiveImageWithNavigation: Plane {
        let image = InteractiveImage()
        let navigator = InteractiveNavigator()

        override func updateLayout() {
            image.layout.make { make in
                make.top = 0
                make.bottom = 0
                make.leftRight = 57
                make.fit(.init(width: 284, height: 434))
                make.centerX = 0
            }

            navigator.layout.make { make in
                make.height = 312
                make.width = 88
                make.left = max(0, image.layout.left - make.width / 2)
                make.centerY = 0
            }
        }
    }

    // MARK: - Main image

    final class InteractiveImage: Plane {
        let image1 = Image { it, ds in
            it.isAutoSize = false
            it.contentMode = .scaleAspectFill
            it.image = ds.images.onboardingHowItWorksItems[safe: 0]?.photo
        }

        let image2 = Image { it, ds in
            it.isAutoSize = false
            it.contentMode = .scaleAspectFill
            it.image = ds.images.onboardingHowItWorksItems[safe: 1]?.photo
        }

        let image3 = Image { it, ds in
            it.isAutoSize = false
            it.contentMode = .scaleAspectFill
            it.image = ds.images.onboardingHowItWorksItems[safe: 2]?.photo
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
                make.shape = ds.shapes.onboardingImageL
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

    // MARK: - Navigator

    final class InteractiveNavigator: Shadow {
        let item1 = NavigationItem { it, ds in
            it.image.image = ds.images.onboardingHowItWorksItems[safe: 0]?.preview
        }

        let item2 = NavigationItem { it, ds in
            it.image.image = ds.images.onboardingHowItWorksItems[safe: 1]?.preview
        }

        let item3 = NavigationItem { it, ds in
            it.image.image = ds.images.onboardingHowItWorksItems[safe: 2]?.preview
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
            shadowColor = ds.colors.primary.withAlphaComponent(0.12)
            shadowOffset = .init(width: 0, height: 2.55)
            shadowRadius = 13.2
            shadowOpacity = 1

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

    // MARK: - Navigation Item

    final class NavigationItem: PlainButton {
        var zoom: CGFloat = 0

        let image = Image { it, _ in
            it.contentMode = .scaleAspectFit
            it.isAutoSize = false
        }

        override func setup() {
            view.backgroundColor = ds.colors.background
        }

        override func updateLayout() {
            layout.make { make in
                make.width = 64 + zoom * 24 // 64 ... 88
                make.height = 88 + zoom * 32 // 88 ... 120
                make.shape = ds.shapes.onboardingImageS // 9.6 + zoom * 3.6 // 9.6 ... 13.2
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
