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
import AiutaCore
import Resolver

extension GalleryView {
    final class Thumb: Recycle<Aiuta.UserImage> {
        final class ScrollRecycler: VRecycler<Thumb, Aiuta.UserImage> {
            override func setup() {
                contentInsets = .init(horizontal: 8)
                contentSpace = .init(square: 4)
                contentFraction = .init(width: .fraction(1), height: .widthMultiplyer(1 / layout.screen.size.aspectRatio))
            }
        }

        let area = ErrorImage { it, ds in
            it.color = ds.colors.neutral
        }

        let generagedImage = Image { it, _ in
            it.desiredQuality = .thumbnails
            it.contentMode = .scaleAspectFill
        }

        var isSelected = false {
            didSet {
                guard isSelected != oldValue else { return }
                animations.animate { [self] in
                    updateSelected()
                }
            }
        }

        override func setup() {
            area.link(with: generagedImage)
            view.borderWidth = 3
            updateSelected()
        }

        private func updateSelected() {
            view.borderColor = ds.colors.onDark.withAlphaComponent(isSelected ? 1 : 0.2)
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

            layout.make { make in
                make.shape = ds.shapes.imageM
            }
        }

        override func update(_ data: Aiuta.UserImage?, at index: ItemIndex) {
            generagedImage.source = data
        }
    }
}
