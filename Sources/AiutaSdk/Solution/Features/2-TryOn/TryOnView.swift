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

final class TryOnView: Plane {
    let navBar = NavBar { it, ds in
        if ds.config.appearance.preferRightClose {
            it.style = .actionTitleClose
        } else {
            it.style = .closeTitleAction
        }
        it.actionStyle = .icon(.history)
        it.title = L.appBarVirtualTryOn
    }

    let area = Stroke { it, ds in
        it.color = ds.color.neutral
    }

    let placeholder = Image { it, ds in
        it.image = ds.image.tryOn(.photoPlaceholder)
        it.tint = ds.color.neutral3
        it.view.maxOpacity = 0.5
    }

    let lastImage = Image { it, _ in
        it.desiredQuality = .hiResImage
        it.contentMode = .scaleAspectFill
        it.isAutoSize = false
    }

    let uploadButton = LabelButton { it, ds in
        it.font = ds.font.buttonS
        it.color = ds.color.brand
        it.label.color = ds.color.onDark
        it.label.minScale = 0.5
        it.text = L.imageSelectorUploadButton
    }

    let changeButton = ChangePhotoButton { it, _ in
        it.view.isVisible = false
    }

    let disclaimer = Label { it, ds in
        it.isHtml = true
        it.isMultiline = true
        it.alignment = .center
        it.font = ds.font.description
        it.color = ds.color.secondary
        it.attach(ds.image.icon16(.lock), bounds: .init(x: 0, y: -3, square: 16))
        it.text = L.imageSelectorProtectionPoint
    }

    let poweredBy = PoweredBy()

    let tryOnBar = TryOnBar { it, _ in
        it.view.isVisible = false
    }

    @bulletin
    var skuBulletin = ProductBulletin { it, ds in
        it.wishButton.view.isVisible = ds.config.behavior.isWishlistAvailable
    }

    override func updateLayout() {
        area.layout.make { make in
            make.leftRight = 50
            make.top = navBar.layout.bottomPin + 16
            make.bottom = layout.safe.insets.bottom + 169
            make.radius = ds.dimensions.imageMainRadius
        }

        lastImage.layout.make { make in
            make.frame = area.layout.frame
            make.radius = ds.dimensions.imageMainRadius
        }

        poweredBy.layout.make { make in
            make.centerX = 0
            make.bottom = layout.safe.insets.bottom + 16
        }

        disclaimer.layout.make { make in
            make.top = area.layout.bottomPin + 16
            make.leftRight = 75
        }

        uploadButton.layout.make { make in
            make.height = 44
            make.width = area.layout.width - 90
            make.centerX = 0
            make.bottom = area.layout.bottom + 28
            make.radius = ds.dimensions.buttonLargeRadius
        }

        changeButton.layout.make { make in
            make.centerX = 0
            make.bottom = area.layout.bottom + 22
        }

        placeholder.layout.make { make in
            make.centerX = 0
            make.centerY = area.layout.centerY - 32
        }
    }
}
