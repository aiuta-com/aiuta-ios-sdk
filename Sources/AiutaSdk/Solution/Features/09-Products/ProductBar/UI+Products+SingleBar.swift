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

extension Sdk.UI.Products {
    final class SingleProductBar: PlainButton {
        var product: Aiuta.Product? {
            didSet {
                image.source = product?.imageUrls.first
                brand.text = product?.brand.uppercased()
                title.text = product?.title
                view.isVisible = product.isSome
            }
        }
        
        let stroke = Stroke { it, ds in
            it.color = ds.colors.neutral
        }

        let image = Image { it, ds in
            it.contentMode = .scaleAspectFit
            it.desiredQuality = .thumbnails
        }

        let brand = Label { it, ds in
            it.font = ds.fonts.brand
            it.color = ds.colors.primary
        }

        let title = Label { it, ds in
            it.font = ds.fonts.product
            it.color = ds.colors.primary
        }

        let arrow = Image { it, ds in
            it.image = ds.icons.arrow16
            it.tint = ds.colors.primary
        }

        override func updateLayout() {
            layout.make { make in
                make.leftRight = 0
                make.height = 88
            }

            stroke.layout.make { make in
                make.left = 16
                make.width = 54
                make.height = 56
                make.centerY = 0
                make.shape = ds.shapes.imageS
            }
            
            image.layout.make { make in
                make.frame = stroke.layout.frame - 8
            }

            arrow.layout.make { make in
                make.square = 16
                make.right = 13
                make.centerY = 0
            }

            brand.layout.make { make in
                make.top = stroke.layout.top + 9
                make.left = stroke.layout.rightPin + 11
                make.right = arrow.layout.leftPin + 17
            }

            title.layout.make { make in
                make.top = brand.layout.bottomPin + 3
                make.left = brand.layout.left
                make.right = brand.layout.right
            }
        }
    }
}
