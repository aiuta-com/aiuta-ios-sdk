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



final class AiutaTryOnMoreSkuCell: Recycle<Aiuta.SkuInfo> {
    final class ScrollRecycler: Recycler<AiutaTryOnMoreSkuCell, Aiuta.SkuInfo> {
        override func setup() {
            contentInsets = .init(horizontal: 16, vertical: 8)
            contentSpace = .init(width: 7, height: 8)
            contentFraction = .init(width: .fractionMaxWidth(0.5, 230), height: .widthMultiplyer(1.7))
        }
    }

    let mainImage = Image { it, _ in
        it.view.isHiRes = true
        it.isAutoSize = false
        it.contentMode = .scaleAspectFill
    }

    let storeTitle = Label { it, ds in
        it.font = ds.font.skuCellStore
    }

    let skuTitle = Label { it, ds in
        it.font = ds.font.skuCellTitle
        it.isMultiline = true
    }

    let skuPrice = Label { it, ds in
        it.font = ds.font.skuCellPrice
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

    override func setup() {
        view.borderColor = ds.color.lightGray
        view.borderWidth = 1
    }

    override func update(_ data: Aiuta.SkuInfo?, at index: ItemIndex) {
        mainImage.imageUrl = data?.imageUrls.first
        skuTitle.text = data?.localizedTitle
        storeTitle.text = data?.localizedBrand.uppercased()
        if (data?.localizedOldPrice).isSome {
            skuPrice.font = ds.font.skuBarOldPrice
            skuPrice.text = data?.localizedOldPrice
            skuPrice2.text = data?.localizedPrice
        } else {
            skuPrice.font = ds.font.skuBarPrice
            skuPrice.text = data?.localizedPrice
        }
        skuDiscount.text = data?.localizedDiscount
        skuDiscount.view.isVisible = skuDiscount.text.isSome
    }

    override func updateLayout() {
        mainImage.layout.make { make in
            make.leftRight = 8
            make.top = 8
            make.bottom = 93
            make.radius = 8
        }

        storeTitle.layout.make { make in
            make.leftRight = 8
            make.top = mainImage.layout.bottomPin + 12
        }

        skuPrice.layout.make { make in
            make.left = 8
            make.bottom = 11.5
        }

        skuPrice2.layout.make { make in
            make.left = skuPrice.layout.rightPin + 4
            make.centerY = skuPrice.layout.centerY - 1
        }

        skuDiscount.layout.make { make in
            make.left = mainImage.layout.left + 8
            make.bottom = mainImage.layout.bottom + 7
            make.radius = 4
        }

        skuTitle.layout.make { make in
            make.leftRight = 8
            make.top = storeTitle.layout.bottomPin + 2
            make.bottom = skuPrice.layout.topPin + 6
        }

        layout.make { make in
            make.radius = 16
        }
    }
}
