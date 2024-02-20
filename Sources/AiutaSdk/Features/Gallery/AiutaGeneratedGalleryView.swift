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

import AiutaKit

final class AiutaGeneratedGalleryView: AiutaGalleryView<Aiuta.GeneratedImage, AiutaGenratedGalleryCell> {
    let swipeEdge = SwipeEdge()

    let closeButton = ImageButton { it, ds in
        it.image = ds.image.sdk(.aiutaClose)
        it.tint = ds.color.item

        it.transitions.make { make in
            make.scale(0)
            make.global()
        }
    }

    let shareButton = LabelButton { it, ds in
        it.font = ds.font.navAction.changing(size: 15)
        it.label.color = ds.color.item
        it.text = "Share"

        it.transitions.make { make in
            make.scale(0)
            make.global()
        }
    }

    override func setup() {
        super.setup()
        galleryViewInset = 0
        view.backgroundColor = .black
    }

    override func updateLayout() {
        super.updateLayout()

        closeButton.layout.make { make in
            make.left = 0
            make.top = layout.safe.insets.top + 2
        }

        shareButton.layout.make { make in
            make.right = 0
            make.centerY = closeButton.layout.centerY
        }
    }
}

final class AiutaGenratedGalleryCell: AiutaGalleryItemView<Aiuta.GeneratedImage> {
    let zoomView = ZoomImage { it, _ in
        it.transitions.make { make in
            make.noFade()
            make.global()
        }
    }

    override func update(_ data: Aiuta.GeneratedImage?) {
        zoomView.imageView.transitions.reference = data
        zoomView.imageView.view.loadImage(data?.imageUrl) { [weak zoomView] in
            zoomView?.imageView.gotImage.fire()
        }
    }

    override func setIndex(_ newIndex: Int, relativeTo currentIndex: Int) {
        super.setIndex(newIndex, relativeTo: currentIndex)
        zoomView.imageView.transitions.isReferenceActive = newIndex == currentIndex
        zoomView.view.setZoomScale(zoomView.view.minimumZoomScale, animated: true)
    }

    override func updateLayout() {
        zoomView.layout.make { make in
            make.size = layout.size
        }
    }
}
