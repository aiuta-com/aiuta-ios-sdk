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

final class GalleryPage: Page<ImageSource> {
    let area = ErrorImage { it, _ in
        it.color = .white.withAlphaComponent(0.1)
        it.errorIcon.tint = .white
    }

    let zoomView = ZoomImage()

    override func setup() {
        area.link(with: zoomView.imageView, whole: true)
    }

    override func update(_ data: ImageSource?) {
        zoomView.imageView.source = data
    }

    override func updateLayout() {
        area.layout.make { make in
            make.leftRight = 0
            make.top = 130
            make.bottom = 130
        }

        zoomView.layout.make { make in
            make.inset = .zero
        }
    }
}
