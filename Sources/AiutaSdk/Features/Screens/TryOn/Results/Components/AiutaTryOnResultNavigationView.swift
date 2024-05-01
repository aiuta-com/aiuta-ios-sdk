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

final class AiutaTryOnResultNavigationView: Scroll {
    @scrollable
    var items = AiutaTryOnResultNavigationItemView.ScrollRecycler()
}

final class AiutaTryOnResultNavigationItemView: Recycle<Aiuta.SessionResult> {
    final class ScrollRecycler: Recycler<AiutaTryOnResultNavigationItemView, Aiuta.SessionResult> {
        override func setup() {
            contentInsets = .init(top: 20, bottom: 20)
            contentSpace = .init(width: 0, height: 10)
            contentFraction = .init(width: .constant(54), height: .constant(96))
        }
    }

    var imageViews: [Image] {
        findChildren()
    }

    let toner = Stroke { it, ds in
        it.color = ds.color.item.withAlphaComponent(0.5)
    }

    let spinner = Spinner()

    var imageUrls: [String] = [] {
        didSet {
            guard oldValue != imageUrls else { return }
            imageViews.indexed.forEach { i, v in
                guard i < imageUrls.count else {
                    v.source = nil
                    v.view.isVisible = false
                    return
                }

                v.source = imageUrls[i]
                v.view.isVisible = true
            }
        }
    }

    var images: [UIImage] = [] {
        didSet {
            guard oldValue != images else { return }
            imageViews.indexed.forEach { i, v in
                guard i < images.count else {
                    v.source = nil
                    v.view.isVisible = false
                    return
                }

                v.source = images[i]
                v.view.isVisible = true
            }
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
                it.desiredQuality = .thumbnails
                it.contentMode = .scaleAspectFill
                it.view.clipsToBounds = true
            })
        }

        toner.bringToFront()
        spinner.bringToFront()
    }

    override func update(_ data: Aiuta.SessionResult?, at index: ItemIndex) {
        guard let data else {
            images = []
            imageUrls = []
            spinner.isSpinning = false
            updateLayout()
            return
        }

        switch data {
            case let .output(img, _):
                images = []
                imageUrls = [img.imageUrl]
                toner.view.isVisible = false
                spinner.isSpinning = false
            case let .sku(sku):
                images = []
                imageUrls = sku.imageUrls
                toner.view.isVisible = false
                spinner.isSpinning = false
            case let .input(input, _):
                toner.view.isVisible = true
                spinner.isSpinning = true
                switch input {
                    case let .uploadedImage(uploadedImage):
                        images = []
                        imageUrls = [uploadedImage.url]
                    case let .capturedImage(capturedImage):
                        imageUrls = []
                        images = [capturedImage]
                }
        }

        updateLayout()
    }

    override func updateLayout() {
        switch max(imageUrls.count, images.count) {
            case 0 ... 1: layout1()
            case 2: layout2()
            case 3: layout3()
            default: layout4()
        }

        layout.make { make in
            make.radius = 16
        }

        toner.layout.make { make in
            make.inset = 0
        }

        spinner.layout.make { make in
            make.center = .zero
        }
    }

    private func layout1() {
        imageViews.indexed.forEach { _, v in
            v.layout.make { make in
                make.inset = 0
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
