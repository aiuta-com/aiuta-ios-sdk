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
import Resolver

extension HistoryView {
    final class HistoryCell: Recycle<Aiuta.GeneratedImage> {
        final class ScrollRecycler: Recycler<HistoryCell, Aiuta.GeneratedImage> {
            override func setup() {
                contentInsets = .init(inset: 8)
                contentSpace = .init(square: 8)
                contentFraction = .init(width: .fractionMaxWidth(1 / 3, 140), height: .widthMultiplyer(18 / 12))
            }
        }

        let generagedImage = Image { it, ds in
            it.desiredQuality = .thumbnails
            it.contentMode = .scaleAspectFill
            it.view.backgroundColor = ds.color.neutral
        }

        let selector = Selector { it, _ in
            it.view.isVisible = false
        }

        var isSelectable = false {
            didSet {
                guard oldValue != isSelectable else { return }
                selector.animations.visibleTo(isSelectable, showTime: .sixthOfSecond, hideTime: .sixthOfSecond)
                if !isSelectable { isSelected = false }
            }
        }

        var isSelected = false {
            didSet {
                guard oldValue != isSelected else { return }
                selector.animations.visibleTo(isSelectable, showTime: .sixthOfSecond, hideTime: .sixthOfSecond)
                selector.isSelected = isSelected
            }
        }

        override func updateLayout() {
            generagedImage.layout.make { make in
                make.size = layout.size
                make.radius = ds.dimensions.imagePreviewRadius
            }

            selector.layout.make { make in
                make.top = 6
                make.right = 6
            }
        }

        override func update(_ data: Aiuta.GeneratedImage?, at index: ItemIndex) {
            generagedImage.source = data
        }
    }

    final class Selector: Stroke {
        var isSelected = false {
            didSet {
                guard oldValue != isSelected else { return }
                check.view.isVisible = isSelected
                color = isSelected ? ds.color.brand : .white.withAlphaComponent(0.7)
                animations.transition(.transitionCrossDissolve, duration: .sixthOfSecond)
            }
        }

        let check = Image { it, ds in
            it.tint = .white
            it.image = ds.image.icon20(.check)
            it.view.isVisible = false
        }

        override func setup() {
            view.borderWidth = 1
            view.borderColor = .white
            color = .white.withAlphaComponent(0.7)
        }

        override func updateLayout() {
            layout.make { make in
                make.circle = 24
            }

            check.layout.make { make in
                make.circle = 20
                make.center = .zero
            }
        }
    }
}
