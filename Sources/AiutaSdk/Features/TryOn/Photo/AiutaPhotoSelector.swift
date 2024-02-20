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
import UIKit

final class AiutaPhotoSelector: Plane {
    enum Source: Equatable {
        case placeholder
        case capturedImage(UIImage)
        case uploadedImage(Aiuta.UploadedImage)
    }

    var source: Source = .placeholder {
        didSet {
            guard source != oldValue else { return }
            switch source {
                case .placeholder:
                    preview.image = ds.image.sdk(.aiutaPlaceholder)
                    hasPreview = false
                case let .capturedImage(capturedImage):
                    preview.image = capturedImage
                    hasPreview = true
                case let .uploadedImage(uploadedImage):
                    preview.imageUrl = uploadedImage.url
                    hasPreview = true
            }
        }
    }

    var hasPreview = false {
        didSet {
            guard oldValue != hasPreview else { return }
            changePhoto.color = hasPreview ? .white : ds.color.accent
            changePhoto.font = hasPreview ? ds.font.secondary : ds.font.button
            changePhoto.text = hasPreview ? "Change photo" : "Upload a photo of you"
            changePhoto.view.borderWidth = hasPreview ? 2 : 0
            preview.contentMode = hasPreview ? .scaleAspectFill : .scaleAspectFit
        }
    }

    let preview = Image { it, ds in
        it.isAutoSize = false
        it.view.isHiRes = true
        it.contentMode = .scaleAspectFit
        it.image = ds.image.sdk(.aiutaPlaceholder)
    }

    let changePhoto = LabelButton { it, ds in
        it.font = ds.font.button
        it.color = ds.color.accent
        it.text = "Upload a photo of you"
        it.view.borderColor = 0xCCCCCCFF.uiColor
    }

    override func setup() {
        view.backgroundColor = ds.color.item
    }

    override func updateLayout() {
        let s = layout.boundary.width / 350

        layout.make { make in
            make.width = 269 * s
            make.height = 130 + 349 * s
            make.radius = 24
        }

        preview.layout.make { make in
            make.width = 195 * s
            make.height = 349 * s
            make.radius = 8
            make.top = 37
            make.centerX = 0
        }

        changePhoto.layout.make { make in
            make.width = 180 * s
            make.height = 37
            make.radius = 8
            make.top = preview.layout.bottomPin + 26
            make.centerX = 0
        }
    }
}
