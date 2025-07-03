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
    final class HistoryCell: Recycle<Aiuta.Image.Generated> {
        final class ScrollRecycler: VRecycler<HistoryCell, Aiuta.Image.Generated> {
            override func setup() {
                contentInsets = .init(inset: 8)
                contentSpace = .init(square: 8)
                contentFraction = .init(width: .fractionMaxWidth(1 / 3, 140), height: .widthMultiplyer(18 / 12))
            }
        }

        let area = ErrorImage { it, ds in
            it.color = ds.colors.neutral
        }

        let generagedImage = Image { it, _ in
            it.desiredQuality = .thumbnails
            it.contentMode = .scaleAspectFill
        }

        let deleter = ActivityIndicator { it, ds in
            it.hasOverlay = true
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

        var isDeleting = false {
            didSet {
                guard oldValue != isDeleting else { return }
                if isDeleting { isSelectable = false }
                deleter.isAnimating = isDeleting
            }
        }

        override func setup() {
            area.link(with: generagedImage)
        }

        override func updateLayout() {
            area.layout.make { make in
                make.inset = 0
                make.shape = ds.shapes.imageM
            }

            generagedImage.layout.make { make in
                make.size = layout.size
                make.shape = ds.shapes.imageM
            }

            selector.layout.make { make in
                make.top = 6
                make.right = 6
            }
        }

        override func update(_ data: Aiuta.Image.Generated?, at index: ItemIndex) {
            generagedImage.source = data
        }
    }

    final class Selector: Stroke {
        var isSelected = false {
            didSet {
                guard oldValue != isSelected else { return }
                check.view.isVisible = isSelected
                color = isSelected ? ds.colors.brand : .white.withAlphaComponent(0.7)
                animations.transition(.transitionCrossDissolve, duration: .sixthOfSecond)
            }
        }

        let check = Image { it, ds in
            it.tint = .white
            it.image = ds.icons.check20
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
