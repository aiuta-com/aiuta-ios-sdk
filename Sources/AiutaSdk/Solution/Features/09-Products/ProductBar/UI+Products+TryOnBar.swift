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
    final class TryOnBar: Shadow {
        var products: Aiuta.Products? {
            didSet {
                guard let products else {
                    productButton.product = nil
                    thumbnailsBar.products = nil
                    return
                }
                if products.count == 1 {
                    productButton.product = products.first
                    thumbnailsBar.products = nil
                } else {
                    thumbnailsBar.products = products
                    productButton.product = nil
                }
                
                updateLayout()
            }
        }

        let productButton = SingleProductBar()
        let thumbnailsBar = ThumbnailsBar()
        let tryOnButton = TryOnButton()

        override func setup() {
            shadowColor = ds.colors.primary.withAlphaComponent(0.04)
            shadowOffset = .init(width: 0, height: -10)
            shadowRadius = 15
            shadowOpacity = 1
            customLayout = true
            stroke.color = ds.colors.background
        }

        override func updateLayout() {
            layout.make { make in
                make.leftRight = 0
            }

            tryOnButton.layout.make { make in
                make.height = 50
                make.shape = ds.shapes.buttonM

                if productButton.view.isVisible {
                    make.leftRight = 16
                    make.top = productButton.layout.bottomPin
                } else if thumbnailsBar.view.isVisible {
                    make.left = thumbnailsBar.layout.rightPin + 20
                    make.right = 20
                    make.top = thumbnailsBar.layout.top + thumbnailsBar.layout.height / 2 - make.height / 2
                }
            }

            layout.make { make in
                make.leftRight = 0
                make.height = tryOnButton.layout.bottomPin + 8 + layout.safe.insets.bottom
                make.bottom = 0
            }

            stroke.layout.make { make in
                make.leftRight = 0
                make.top = 0
                make.shape = ds.shapes.bottomSheet
                make.bottom = -ds.shapes.bottomSheet.radius
            }
        }
    }
}
