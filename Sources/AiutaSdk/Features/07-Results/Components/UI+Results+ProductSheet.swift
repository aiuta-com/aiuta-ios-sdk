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

import AiutaCore
@_spi(Aiuta) import AiutaKit
import UIKit

@available(iOS 13.0.0, *)
extension ResultsView {
    final class ProductSheet: VScroll {
        var onTapImage: Signal<Int> { content.singleItemContent.onTapImage }
        var onTapProduct: Signal<Aiuta.Product> { content.multiItemContent.onTapProduct }

        var products: Aiuta.Products? {
            didSet {
                guard oldValue != products else { return }

                guard let products else {
                    content.singleItemContent.product = nil
                    content.multiItemContent.products = nil
                    return
                }

                if products.count == 1 {
                    content.singleItemContent.product = products.first
                    content.multiItemContent.products = nil
                } else {
                    content.singleItemContent.product = nil
                    content.multiItemContent.products = products
                }

                invalidateLayout()
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
        var isEnabed = false {
            didSet {
                singleItemContent.gallery.view.isUserInteractionEnabled = isEnabed
                multiItemContent.gallery.view.isUserInteractionEnabled = isEnabed
            }
        }

        var opacity: CGFloat = 1 {
            didSet {
                singleItemContent.gallery.view.opacity = opacity
                multiItemContent.gallery.view.opacity = opacity
            }
        }

        let singleItemContent = SingleItemContent()
        let multiItemContent = MultiItemContent()

        override func setup() {
            shadowOffset = .init(width: 0, height: -10)
            shadowColor = .black.withAlphaComponent(0.04)
            shadowRadius = 15
            customLayout = true
            stroke.color = ds.colors.background
        }

        override func updateLayout() {
            subcontents.forEach {
                $0.layout.make { make in
                    make.width = layout.width
                }
            }

            layout.make { make in
                if singleItemContent.view.isVisible {
                    make.height = singleItemContent.layout.height
                } else if multiItemContent.view.isVisible {
                    make.height = multiItemContent.layout.height
                } else {
                    make.height = 300
                }
            }

            stroke.layout.make { make in
                make.top = 0
                make.leftRight = 0
                make.height = layout.screen.height
                make.shape = ds.shapes.bottomSheet
            }
        }
    }

    final class SingleItemContent: Plane {
        let onTapImage = Signal<Int>()

        var product: Aiuta.Product? {
            didSet {
                guard oldValue != product else { return }
                gallery.removeAllContents()
                gallery.scroll(to: -gallery.contentInset.left)

                product?.imageUrls.indexed.forEach { i, imageUrl in
                    gallery.addContent(Sdk.UI.Products.ImageCell()) { it, ds in
                        it.useExtraInset = ds.styles.applyProductFirstImageExtraPadding && i == 0
                        it.image.source = imageUrl
                        it.onTouchUpInside.subscribe(with: self) { [unowned self] in
                            onTapImage.fire(i)
                        }
                    }
                }

                brand.text = product?.brand.uppercased()
                title.text = product?.title
                sizeFit.product = product

                view.isVisible = product.isSome
            }
        }

        let brand = Label { it, ds in
            it.font = ds.fonts.brand
            it.color = ds.colors.secondary
        }

        let title = Label { it, ds in
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

        let sizeFit = SizeFitBar()

        let gallery = HScroll { it, _ in
            it.contentInset = .init(horizontal: 16)
            it.itemSpace = 8
            it.view.opacity = 0.1
        }

        override func setup() {
            view.isVisible = false
        }

        override func updateLayout() {
            layout.make { make in
                make.height = 375
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

            title.layout.make { make in
                if brand.hasText {
                    make.top = brand.layout.bottomPin
                } else {
                    make.top = 20
                }
                make.left = brand.layout.left
                make.right = brand.layout.right
            }

            sizeFit.layout.make { make in
                make.top = max(title.layout.bottomPin, addToCart.layout.bottomPin) + 11
                make.leftRight = 0
            }

            gallery.layout.make { make in
                make.width = layout.width
                make.height = 225
                make.top = sizeFit.layout.bottomPin + 22
            }
        }
    }

    final class MultiItemContent: Plane {
        let onTapProduct = Signal<Aiuta.Product>()

        var products: Aiuta.Products? {
            didSet {
                guard oldValue != products else { return }
                gallery.removeAllContents()
                gallery.scroll(to: -gallery.contentInset.left)

                products?.forEach { product in
                    gallery.addContent(ProductCell()) { it, _ in
                        it.product = product
                        it.onTouchUpInside.subscribe(with: self) { [unowned self] in
                            onTapProduct.fire(product)
                        }
                    }
                }

                view.isVisible = products.isSome
            }
        }

        let title = Label { it, ds in
            it.font = ds.fonts.titleM
            it.color = ds.colors.primary
            it.text = ds.strings.outfitItemsTitle
        }

        let gallery = HScroll { it, _ in
            it.contentInset = .init(horizontal: 16)
            it.itemSpace = 9
            it.view.opacity = 0.1
        }

        let addToCart = LabelButton { it, ds in
            it.labelInsets = .init(horizontal: 40, vertical: 14)
            it.font = ds.fonts.buttonM
            it.color = ds.colors.brand
            it.label.color = ds.colors.onDark
            it.text = ds.strings.shopTheLook
        }

        override func setup() {
            view.isVisible = false
        }

        override func updateLayout() {
            title.layout.make { make in
                make.top = 22
                make.left = 27
            }

            gallery.layout.make { make in
                make.width = layout.width
                make.height = 262
                make.top = title.layout.bottomPin + 20
            }

            addToCart.layout.make { make in
                make.leftRight = 20
                make.top = gallery.layout.bottomPin + 34
                make.shape = ds.shapes.buttonM
            }

            layout.make { make in
                make.height = addToCart.layout.bottomPin + 20
            }
        }
    }

    final class ProductCell: PlainButton {
        var product: Aiuta.Product? {
            didSet {
                guard oldValue != product else { return }
                image.source = product?.imageUrls.first
                useExtraInset = ds.styles.applyProductFirstImageExtraPadding
                brand.text = product?.brand.uppercased()
                title.text = product?.title
            }
        }

        var useExtraInset: Bool = false {
            didSet {
                image.contentMode = useExtraInset ? .scaleAspectFit : .scaleAspectFill
            }
        }

        let storke = Stroke { it, ds in
            it.color = ds.colors.neutral
        }

        let image = Image { it, _ in
            it.contentMode = .scaleAspectFill
            it.desiredQuality = .thumbnails
            it.isAutoSize = false
        }

        let brand = Label { it, ds in
            it.font = ds.fonts.brand
            it.color = ds.colors.primary
            it.isMultiline = false
        }

        let title = Label { it, ds in
            it.font = ds.fonts.product
            it.color = ds.colors.primary
            it.isMultiline = false
        }

        override func updateLayout() {
            layout.make { make in
                make.width = 176
                make.height = 262
            }

            storke.layout.make { make in
                make.width = layout.width
                make.height = 208
                make.shape = ds.shapes.imageM
            }

            image.layout.make { make in
                if useExtraInset {
                    make.frame = storke.layout.frame - 24
                    make.shape = .rectangular
                } else {
                    make.frame = storke.layout.frame
                    make.shape = ds.shapes.imageM
                }
            }

            brand.layout.make { make in
                make.top = storke.layout.bottomPin + 8
                make.left = 0
                make.right = 16
            }

            title.layout.make { make in
                make.left = 0
                make.right = 16
                make.top = brand.layout.bottomPin + 8
            }
        }
    }
}
