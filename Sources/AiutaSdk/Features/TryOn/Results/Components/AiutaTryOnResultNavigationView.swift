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


import UIKit

final class AiutaTryOnResultNavigationView: Scroll {
    @scrollable
    var items = AiutaTryOnResultNavigationItemView.ScrollRecycler()
}

final class AiutaTryOnResultNavigationItemView: Recycle<AiutaTryOnResult> {
    final class ScrollRecycler: Recycler<AiutaTryOnResultNavigationItemView, AiutaTryOnResult> {
        override func setup() {
            contentInsets = .init(top: 20, bottom: 20)
            contentSpace = .init(width: 0, height: 10)
            contentFraction = .init(width: .constant(54), height: .constant(96))
        }
    }

    var imageViews: [Image] {
        findChildren()
    }

    var imageUrls: [String] = [] {
        didSet {
            imageViews.indexed.forEach { i, v in
                guard i < imageUrls.count else {
                    v.imageUrl = nil
                    v.image = nil
                    v.view.isVisible = false
                    return
                }

                v.imageUrl = imageUrls[i]
                v.view.isVisible = true
            }
            updateLayout()
        }
    }

    var isSelected = false {
        didSet {
            guard oldValue != isSelected else { return }
            view.borderColor = ds.color.item.withAlphaComponent(isSelected ? 1 : 0.2)
            animations.transition(.transitionCrossDissolve, duration: .quarterOfSecond)
        }
    }

    override func setup() {
        view.borderWidth = 3
        view.borderColor = ds.color.item.withAlphaComponent(0.2)

        for _ in 0 ..< 4 {
            addContent(Image { it, _ in
                it.view.isHiRes = true
                it.contentMode = .scaleAspectFill
                it.view.clipsToBounds = true
            })
        }
    }

    override func update(_ data: AiutaTryOnResult?, at index: ItemIndex) {
        guard let data else {
            imageUrls = []
            return
        }

        switch data {
            case let .generatedImage(img):
                imageUrls = [img.imageUrl]
            case let .sku(sku):
                imageUrls = sku.imageUrls
        }
    }

    override func updateLayout() {
        switch imageUrls.count {
            case 0 ... 1: layout1()
            case 2: layout2()
            case 3: layout3()
            default: layout4()
        }

        layout.make { make in
            make.radius = 16
        }
    }

    private func layout1() {
        imageViews.indexed.forEach { _, v in
            v.layout.make { make in
                make.size = layout.size
            }
        }
    }

    private func layout2() {
        imageViews.indexed.forEach { i, v in
            v.layout.make { make in
                make.leftRight = 0
                make.top = i == 0 ? 0 : layout.height / 2
                make.bottom = i == 0 ? layout.height / 2 : 0
            }
        }
    }

    private func layout3() {
        imageViews.indexed.forEach { i, v in
            switch i {
                case 0: v.layout.make { make in
                        make.leftRight = 0
                        make.top = 0
                        make.bottom = layout.height / 2
                    }
                case 1: v.layout.make { make in
                        make.left = 0
                        make.right = layout.width / 2
                        make.top = layout.height / 2
                        make.bottom = 0
                    }
                default: v.layout.make { make in
                        make.left = layout.width / 2
                        make.right = 0
                        make.top = layout.height / 2
                        make.bottom = 0
                    }
            }
        }
    }

    private func layout4() {
        imageViews.indexed.forEach { i, v in
            v.layout.make { make in
                make.width = layout.width / 2
                make.height = layout.height / 2
                make.left = i.isOdd ? 0 : layout.width / 2
                make.top = i < 2 ? 0 : layout.height / 2
            }
        }
    }
}
