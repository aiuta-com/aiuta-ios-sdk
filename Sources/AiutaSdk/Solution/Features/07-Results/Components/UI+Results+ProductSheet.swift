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

@available(iOS 13.0.0, *)
extension ResultsView {
    final class ProductSheet: VScroll {
        let onTapImage = Signal<Int>()

        var sku: Aiuta.Product? {
            didSet {
                guard oldValue != sku else { return }
                content.gallery.removeAllContents()
                content.gallery.scroll(to: -content.gallery.contentInset.left)

                sku?.imageUrls.indexed.forEach { i, imageUrl in
                    content.gallery.addContent(Sdk.UI.TryOn.ImageCell()) { it, ds in
                        it.useExtraInset = ds.styles.applyProductFirstImageExtraPadding && i == 0
                        it.image.source = imageUrl
                        it.onTouchUpInside.subscribe(with: self) { [unowned self] in
                            onTapImage.fire(i)
                        }
                    }
                }

                content.brand.text = sku?.brand.uppercased()
                content.product.text = sku?.title
            }
        }

        let content = SkuSheetContent()

        override func setup() {
            tapThroughTopInset = 0
            fastDeceleration = true
            view.isPagingEnabled = true
        }
    }

    final class SkuSheetContent: Shadow {
        let brand = Label { it, ds in
            it.font = ds.fonts.brand
            it.color = ds.colors.primary
        }

        let product = Label { it, ds in
            it.font = ds.fonts.product
            it.color = ds.colors.primary
            it.view.numberOfLines = 2
            it.lineBreak = .byTruncatingTail
        }

        let addToCart = LabelButton { it, ds in
            it.labelInsets = .init(horizontal: 40, vertical: 14)
            it.font = ds.fonts.buttonM
            it.color = ds.colors.brand
            it.label.color = ds.colors.onDark
            it.text = ds.strings.addToCart
        }

        let gallery = HScroll { it, _ in
            it.contentInset = .init(horizontal: 16)
            it.itemSpace = 8
            it.view.opacity = 0.1
        }

        override func setup() {
            shadowOffset = .init(width: 0, height: -10)
            shadowColor = .black.withAlphaComponent(0.04)
            shadowRadius = 15
            customLayout = true
            stroke.color = ds.colors.background
        }

        override func updateLayout() {
            layout.make { make in
                make.height = 375
            }

            stroke.layout.make { make in
                make.top = 0
                make.leftRight = 0
                make.height = layout.screen.height
                make.shape = ds.shapes.bottomSheet
            }

            addToCart.layout.make { make in
                make.top = 20
                make.right = 16
                make.shape = ds.shapes.buttonM
            }

            brand.layout.make { make in
                make.top = 20
                make.left = 16
                make.right = addToCart.layout.leftPin + 16
            }

            product.layout.make { make in
                if brand.hasText {
                    make.top = brand.layout.bottomPin
                } else {
                    make.top = 20
                }
                make.left = brand.layout.left
                make.right = brand.layout.right
            }

            gallery.layout.make { make in
                make.width = layout.width
                make.height = 225
                make.top = max(product.layout.bottomPin, addToCart.layout.bottomPin) + 32
            }
        }
    }
}
