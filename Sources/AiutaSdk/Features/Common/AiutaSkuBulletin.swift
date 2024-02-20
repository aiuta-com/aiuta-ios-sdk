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

final class AiutaSkuBulletin: PlainBulletin {
    var sku: Aiuta.SkuInfo? {
        didSet {
            guard oldValue != sku else { return }
            gallery.removeAllContents()
            gallery.scroll(to: -gallery.contentInset.left)

            sku?.imageUrls.forEach { imageUrl in
                gallery.addContent(ImageCell()) { it, _ in
                    it.image.imageUrl = imageUrl
                }
            }

            skuTitle.text = sku?.localizedTitle
            storeTitle.text = sku?.localizedBrand.uppercased()
            if (sku?.localizedOldPrice).isSome {
                skuPrice.font = ds.font.skuBarOldPrice
                skuPrice.text = sku?.localizedOldPrice
                skuPrice2.text = sku?.localizedPrice
            } else {
                skuPrice.font = ds.font.skuBarPrice
                skuPrice.text = sku?.localizedPrice
            }
            skuDiscount.text = sku?.localizedDiscount
            skuDiscount.view.isVisible = skuDiscount.text.isSome
        }
    }

    let gallery = HScroll { it, _ in
        it.contentInset = .init(horizontal: 16)
        it.itemSpace = 8
    }

    let storeTitle = Label { it, ds in
        it.font = ds.font.skuBulletinStore
    }

    let skuTitle = Label { it, ds in
        it.font = ds.font.skuBulletinTitle
        it.isMultiline = true
    }

    let skuPrice = Label { it, ds in
        it.font = ds.font.skuBarPrice
    }

    let skuPrice2 = Label { it, ds in
        it.font = ds.font.skuBarNewPrice
    }

    let skuDiscount = LabelButton { it, ds in
        it.view.isVisible = false
        it.view.isUserInteractionEnabled = false
        it.labelInsets = .init(horizontal: 4, vertical: 1)
        it.font = ds.font.skuBarDiscount
        it.color = ds.color.red
    }

    let primaryButton = LabelButton { it, ds in
        it.font = ds.font.buttonBig
        it.color = ds.color.accent
        it.text = "Try on"
    }

    let secondaryButton = LabelButton { it, ds in
        it.font = ds.font.buttonBig
        it.color = ds.color.item
        it.text = "More details"
        it.label.color = ds.color.tint
        it.view.borderColor = 0xCCCCCCFF.uiColor
        it.view.borderWidth = 2
    }

    override func updateLayout() {
        gallery.layout.make { make in
            make.width = layout.width
            make.height = 202
        }

        storeTitle.layout.make { make in
            make.leftRight = gallery.contentInset.left
            make.top = gallery.layout.bottomPin + 16
        }

        skuTitle.layout.make { make in
            make.leftRight = storeTitle.layout.left
            make.top = storeTitle.layout.bottomPin + 2
        }

        skuPrice.layout.make { make in
            make.left = skuTitle.layout.left
            make.top = skuTitle.layout.bottomPin + 5.5
        }

        skuPrice2.layout.make { make in
            make.left = skuPrice.layout.rightPin + 4
            make.centerY = skuPrice.layout.centerY - 1
        }

        skuDiscount.layout.make { make in
            make.left = skuPrice2.layout.rightPin + 8
            make.centerY = skuPrice2.layout.centerY
            make.radius = 4
        }

        let buttonWidth = layout.width / 2 - 20

        secondaryButton.layout.make { make in
            make.width = buttonWidth
            make.height = 50
            make.left = 16
            make.top = skuPrice.layout.bottomPin + 24
            make.radius = 8
        }

        primaryButton.layout.make { make in
            make.width = buttonWidth
            make.height = 50
            make.right = 16
            make.top = secondaryButton.layout.top
            make.radius = 8
        }

        layout.make { make in
            make.height = secondaryButton.layout.bottomPin + 12
        }
    }

    convenience init(sku: Aiuta.SkuInfo) {
        self.init()
        self.sku = sku
    }

    convenience init(_ builder: (_ it: AiutaSkuBulletin, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}

extension AiutaSkuBulletin {
    final class ImageCell: Plane {
        let image = Image { it, ds in
            it.view.backgroundColor = ds.color.lightGray
            it.contentMode = .scaleAspectFill
            it.isAutoSize = false
        }

        override func updateLayout() {
            layout.make { make in
                make.width = 154
                make.height = 202
            }

            image.layout.make { make in
                make.size = layout.size
                make.radius = 8
            }
        }
    }
}
