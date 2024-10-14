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

extension TryOnView {
    final class TryOnBar: Shadow {
        var product: Aiuta.Product? {
            didSet {
                productButton.image.source = product?.imageUrls.first
                productButton.brand.text = product?.localizedBrand.uppercased()
                productButton.product.text = product?.localizedTitle
            }
        }

        let productButton = ProductBar()
        let tryOnButton = TryOnButton()

        override func setup() {
            shadowColor = ds.color.primary.withAlphaComponent(0.04)
            shadowOffset = .init(width: 0, height: -10)
            shadowRadius = 15
            shadowOpacity = 1
            customLayout = true
            stroke.color = ds.color.ground
        }

        override func updateLayout() {
            layout.make { make in
                make.leftRight = 0
            }

            tryOnButton.layout.make { make in
                make.leftRight = 16
                make.height = 50
                make.radius = ds.dimensions.buttonLargeRadius
                make.top = productButton.layout.bottomPin
            }

            layout.make { make in
                make.leftRight = 0
                make.height = tryOnButton.layout.bottomPin + 8 + layout.safe.insets.bottom
                make.bottom = 0
            }

            stroke.layout.make { make in
                make.leftRight = 0
                make.top = 0
                make.radius = ds.dimensions.bottomSheetRadius
                make.bottom = -ds.dimensions.bottomSheetRadius
            }
        }
    }

    final class ProductBar: PlainButton {
        let image = Image { it, ds in
            it.view.backgroundColor = ds.color.neutral
            it.view.borderColor = ds.color.neutral2
            it.view.borderWidth = 1
            it.contentMode = .scaleAspectFit
            it.desiredQuality = .thumbnails
        }

        let brand = Label { it, ds in
            it.font = ds.font.brand
            it.color = ds.color.primary
        }

        let product = Label { it, ds in
            it.font = ds.font.product
            it.color = ds.color.primary
        }

        let arrow = Image { it, ds in
            it.image = ds.image.icon16(.arrow)
            it.tint = ds.color.primary
        }

        override func updateLayout() {
            layout.make { make in
                make.leftRight = 0
                make.height = 72
            }

            image.layout.make { make in
                make.left = 16
                make.width = 28
                make.height = 40
                make.centerY = 0
                make.radius = 4
            }

            arrow.layout.make { make in
                make.square = 16
                make.right = 13
                make.centerY = 0
            }

            brand.layout.make { make in
                make.top = image.layout.top + 1
                make.left = image.layout.rightPin + 11
                make.right = arrow.layout.leftPin + 17
            }

            product.layout.make { make in
                make.top = brand.layout.bottomPin + 3
                make.left = brand.layout.left
                make.right = brand.layout.right
            }
        }
    }
}
