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


import UIKit

final class AiutaTryOnResultFooterView: Plane {
    let blur = Blur { it, _ in
        it.style = .extraLight
    }

    let addToCart = LabelButton { it, ds in
        it.font = ds.font.buttonBig
        it.color = ds.color.accent
        it.text = "Add to cart"
    }

    let addToWishlist = LabelButton { it, ds in
        it.font = ds.font.buttonBig
        it.color = ds.color.item
        it.text = "Add to wishlist"
        it.label.color = ds.color.tint
        it.view.borderColor = 0xCCCCCCFF.uiColor
        it.view.borderWidth = 2
    }

    override func updateLayout() {
        layout.make { make in
            make.width = layout.boundary.width
            make.height = layout.safe.insets.bottom + 72
        }

        blur.layout.make { make in
            make.size = layout.size
        }

        let buttonWidth = layout.width / 2 - 20

        addToWishlist.layout.make { make in
            make.width = buttonWidth
            make.height = 50
            make.left = 16
            make.top = 10
            make.radius = 8
        }

        addToCart.layout.make { make in
            make.width = buttonWidth
            make.height = 50
            make.right = 16
            make.top = 10
            make.radius = 8
        }
    }
}
