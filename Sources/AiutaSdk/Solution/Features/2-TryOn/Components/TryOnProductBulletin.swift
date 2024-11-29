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

extension TryOnView {
    final class ProductBulletin: PlainBulletin {
        let onTapImage = Signal<Int>()

        var sku: Aiuta.Product? {
            didSet {
                guard oldValue != sku else { return }
                gallery.removeAllContents()
                gallery.scroll(to: -gallery.contentInset.left)

                sku?.imageUrls.indexed.forEach { i, imageUrl in
                    gallery.addContent(ImageCell()) { it, ds in
                        it.useExtraInset = ds.config.appearance.toggles.applyProductFirstImageExtraInset && i == 0
                        it.image.source = imageUrl
                        it.onTouchUpInside.subscribe(with: self) { [unowned self] in
                            onTapImage.fire(i)
                        }
                    }
                }

                brand.text = sku?.localizedBrand.uppercased()
                title.text = sku?.localizedTitle
            }
        }

        let gallery = HScroll { it, _ in
            it.contentInset = .init(horizontal: 16)
            it.itemSpace = 8
        }

        let brand = Label { it, ds in
            it.font = ds.font.brand
            it.color = ds.color.primary
        }

        let title = Label { it, ds in
            it.font = ds.font.product
            it.color = ds.color.primary
            it.isMultiline = true
        }

        let cartButton = LabelButton { it, ds in
            it.font = ds.font.button
            it.color = ds.color.brand
            it.label.color = ds.color.onDark
            it.text = L.addToCart
        }

        let wishButton = WishlistButton()

        override func setup() {
            maxWidth = 600
            strokeWidth = ds.dimensions.grabberWidth
            strokeOffset = ds.dimensions.grabberOffset
            cornerRadius = ds.dimensions.bottomSheetRadius
            view.backgroundColor = ds.color.ground
            wishButton.view.isVisible = ds.config.behavior.isWishlistAvailable
        }

        override func updateLayout() {
            gallery.layout.make { make in
                make.width = layout.width
                make.height = 225
                make.top = 8
            }

            brand.layout.make { make in
                make.leftRight = gallery.contentInset.left
                make.top = gallery.layout.bottomPin + 18
            }

            title.layout.make { make in
                make.leftRight = brand.layout.left
                make.top = brand.layout.bottomPin
            }

            let buttonWidth = layout.width / 2 - 20

            wishButton.layout.make { make in
                make.width = buttonWidth
                make.height = 50
                make.left = 16
                make.top = title.layout.bottomPin + 26
                make.radius = ds.dimensions.buttonLargeRadius
            }

            cartButton.layout.make { make in
                if wishButton.view.isVisible {
                    make.width = buttonWidth
                } else {
                    make.left = 16
                }
                make.right = 16
                make.height = 50
                make.top = wishButton.layout.top
                make.radius = ds.dimensions.buttonLargeRadius
            }

            layout.make { make in
                make.height = wishButton.layout.bottomPin + 12
            }
        }

        convenience init(sku: Aiuta.Product) {
            self.init()
            self.sku = sku
        }

        convenience init(_ builder: (_ it: ProductBulletin, _ ds: DesignSystem) -> Void) {
            self.init()
            builder(self, ds)
        }
    }

    final class ImageCell: PlainButton {
        var useExtraInset: Bool = false {
            didSet {
                image.contentMode = useExtraInset ? .scaleAspectFit : .scaleAspectFill
            }
        }

        let image = Image { it, _ in
            it.contentMode = .scaleAspectFill
            it.desiredQuality = .thumbnails
            it.isAutoSize = false
        }

        override func setup() {
            view.backgroundColor = ds.color.neutral
        }

        override func updateLayout() {
            layout.make { make in
                make.width = 169
                make.height = 225
                make.radius = ds.dimensions.imagePreviewRadius
            }

            image.layout.make { make in
                if useExtraInset {
                    make.top = 24
                    make.bottom = 40
                    make.leftRight = 24
                } else {
                    make.size = layout.size
                }
                make.radius = ds.dimensions.imagePreviewRadius
            }
        }
    }

    final class WishlistButton: PlainButton {
        var isSelected = false {
            didSet { updateWishIcon() }
        }

        let labelWithIcon = LabelWithIcon()

        override func setup() {
            labelWithIcon.label.font = ds.font.button
            labelWithIcon.label.color = ds.color.primary
            labelWithIcon.label.text = L.addToWish
            labelWithIcon.icon.tint = ds.color.primary
            updateWishIcon()
            
            view.borderColor = ds.color.neutral2
            view.borderWidth = 1
        }

        override func updateLayout() {
            labelWithIcon.icon.layout.make { make in
                make.square = 20
            }

            labelWithIcon.layout.make { make in
                make.center = .zero
            }
        }

        private func updateWishIcon() {
            labelWithIcon.icon.image = ds.image.icon24(isSelected ? .wishlistFill : .wishlist)
        }
    }
}
