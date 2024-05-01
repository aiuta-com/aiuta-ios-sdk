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

final class AiutaTryOnResultCell: Recycle<Aiuta.SessionResult> {
    final class ScrollRecycler: Recycler<AiutaTryOnResultCell, Aiuta.SessionResult> {
        override func setup() {
            contentInsets = .init(vertical: 8)
            contentSpace = .init(square: 8)
            contentFraction = .init(width: .fraction(1), height: .constant(522))
        }
    }

    let generatedImage = Image { it, _ in
        it.isAutoSize = false
        it.contentMode = .scaleAspectFill
        it.transitions.make { make in
            make.noFade()
        }
    }

    let shareView = ShareView { it, _ in
        it.transitions.whenAppear { make in
            make.delay = 0.3
            make.scale(0)
            make.global()
        }
        it.transitions.isActive = false
    }

    var shareButton: ImageButton {
        shareView.shareButton
    }

    let skuGallery = AiutaGalleryView<String, AiutaTryOnResultSkuCell>()

    override func update(_ data: Aiuta.SessionResult?, at index: ItemIndex) {
        generatedImage.view.isVisible = false
        skuGallery.view.isVisible = false
        shareView.view.isVisible = false
        shareView.transitions.isActive = false

        guard let data else {
            generatedImage.transitions.reference = nil
            generatedImage.source = nil
            skuGallery.data = nil
            return
        }

        switch data {
            case let .output(img, _):
                generatedImage.transitions.reference = img
                generatedImage.source = img
                generatedImage.view.isVisible = true
                shareView.view.isVisible = true
                shareView.transitions.isActive = true
                skuGallery.data = nil
            case let .sku(sku):
                generatedImage.transitions.reference = nil
                generatedImage.source = nil
                skuGallery.data = DataProvider(sku.imageUrls)
                skuGallery.galleryView.scroll(to: 0, animated: true)
                skuGallery.view.isVisible = true
            case let .input(source, _):
                switch source {
                    case let .capturedImage(uIImage):
                        generatedImage.image = uIImage
                    case let .uploadedImage(uploadedImage):
                        generatedImage.source = uploadedImage
                }
                generatedImage.view.isVisible = true
                shareView.view.isVisible = true
                shareView.transitions.isActive = true
                skuGallery.data = nil
        }
    }

    override func updateLayout() {
        generatedImage.layout.make { make in
            make.leftRight = 50
            make.top = 0
            make.bottom = 0
            make.radius = 24
        }

        shareView.layout.make { make in
            make.top = 10
            make.right = generatedImage.layout.right + 10
        }

        skuGallery.layout.make { make in
            make.size = layout.size
        }
    }
}

extension AiutaTryOnResultCell {
    final class ShareView: Shadow {
        let shareButton = ImageButton { it, ds in
            it.view.backgroundColor = ds.color.item
            it.image = ds.image.sdk(.aiutaShare)
            it.tint = .black
        }

        override func setup() {
            shadowColor = .black
            shadowRadius = 4
            shadowOffset = .init(width: 0, height: 2)
            shadowOpacity = 0.2
        }

        override func updateLayout() {
            layout.make { make in
                make.size = .init(square: 38)
            }

            shareButton.layout.make { make in
                make.circle = 38
            }
        }
    }
}
