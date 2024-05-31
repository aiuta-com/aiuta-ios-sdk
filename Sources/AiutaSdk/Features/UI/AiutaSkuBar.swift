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
import Resolver
import UIKit

final class AiutaSkuBar: PlainButton {
    @Injected private var heroic: Heroic

    let blur = Blur { it, _ in
        it.style = .extraLight
    }

    let preview = Image { it, _ in
        it.isAutoSize = false
        it.contentMode = .scaleAspectFill
        it.desiredQuality = .thumbnails
        it.view.borderColor = 0xD9D9D9FF.uiColor
        it.view.backgroundColor = it.view.borderColor
        it.view.borderWidth = 1
    }

    let storeTitle = Label { it, ds in
        it.font = ds.font.skuBulletinStore
    }

    let skuTitle = Label { it, ds in
        it.font = ds.font.skuBulletinTitle
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
        it.color = ds.color.highlight
    }

    let next = Image { it, ds in
        it.image = ds.image.sdk(.aiutaNext)
    }

    let stroke = Stroke { it, ds in
        it.color = ds.color.gray.withAlphaComponent(0.5)
    }

    var sku: Aiuta.SkuInfo? {
        didSet {
            guard oldValue != sku else { return }
            if #available(iOS 13.0, *) {
                Task {
                    await heroic.completeTransition()
                    preview.source = sku?.imageUrls.first
                }
            } else {
                preview.source = sku?.imageUrls.first
            }
            skuTitle.text = sku?.localizedTitle
            storeTitle.text = sku?.localizedBrand.uppercased()
            if (sku?.localizedOldPrice).isSome {
                skuPrice.font = ds.font.skuBarOldPrice
                skuPrice.text = sku?.localizedOldPrice
                skuPrice2.color = ds.color.highlight
                skuPrice2.text = sku?.localizedPrice
            } else {
                skuPrice.font = ds.font.skuBarPrice
                skuPrice.text = sku?.localizedPrice
                skuPrice2.text = nil
            }
            skuDiscount.text = sku?.localizedDiscount
            skuDiscount.view.isVisible = skuDiscount.text.isSome
        }
    }

    override func updateLayout() {
        layout.make { make in
            make.width = layout.boundary.width
            make.height = 72
        }

        blur.layout.make { make in
            make.size = layout.size
        }

        preview.layout.make { make in
            make.left = 8
            make.top = 8
            make.bottom = 8
            make.width = 40
            make.radius = 8
        }

        next.layout.make { make in
            make.right = 16
            make.centerY = 0
        }
        
        let hasPrices = skuPrice.hasText || skuPrice2.hasText || skuDiscount.label.hasText

        storeTitle.layout.make { make in
            make.left = preview.layout.rightPin + 8
            make.right = next.layout.leftPin + 16
            make.top = hasPrices ? 8 : 18
        }

        skuTitle.layout.make { make in
            make.left = preview.layout.rightPin + 8
            make.right = next.layout.leftPin + 16
            make.top = storeTitle.layout.bottomPin + 2
        }

        skuPrice.layout.make { make in
            make.left = preview.layout.rightPin + 8
            make.top = skuTitle.layout.bottomPin + 3.5
        }

        skuPrice2.layout.make { make in
            make.left = skuPrice.layout.rightPin + 4
            make.centerY = skuPrice.layout.centerY
        }

        skuDiscount.layout.make { make in
            make.left = skuPrice2.layout.rightPin + 8
            make.centerY = skuPrice.layout.centerY
            make.radius = 4
        }

        stroke.layout.make { make in
            make.leftRight = 0
            make.height = 0.5
            make.bottom = 0
        }
    }
}
