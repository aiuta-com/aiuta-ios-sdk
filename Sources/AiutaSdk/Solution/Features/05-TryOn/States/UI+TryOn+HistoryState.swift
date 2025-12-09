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

extension Sdk.UI.TryOn {
    final class PhotoState: Plane {
        let area = ErrorImage { it, ds in
            it.color = ds.colors.neutral
        }

        let lastImage = Image { it, _ in
            it.desiredQuality = .hiResImage
            it.contentMode = .scaleAspectFill
            it.isAutoSize = false
        }

        let changeButton = ChangePhotoButton()

        let tryOnBar = Sdk.UI.Products.TryOnBar()

        override func setup() {
            area.link(with: lastImage)
        }

        override func updateLayout() {
            area.layout.make { make in
                make.leftRight = 50
                make.top = 16
                make.bottom = layout.safe.insets.bottom + 169
                make.shape = ds.shapes.imageL
            }

            lastImage.layout.make { make in
                make.frame = area.layout.frame
                make.shape = ds.shapes.imageL
            }

            changeButton.layout.make { make in
                make.centerX = 0
                make.bottom = area.layout.bottom + 22
            }
        }
    }
}
