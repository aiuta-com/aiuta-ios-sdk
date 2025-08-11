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

extension GalleryView {
    final class Navigator: Scroll {
        @scrollable
        var thumbnails = Thumb.ScrollRecycler()

        private let gradientMaskLayer = CAGradientLayer()

        var selectedIndex: Int = -1 {
            didSet {
                thumbnails.updateItems()
                thumbnails.scroll(to: selectedIndex)
            }
        }

        override func setup() {
            gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
            gradientMaskLayer.locations = [0, 0.03, 0.97, 1]
            view.layer.mask = gradientMaskLayer
            
            thumbnails.onUpdateItem.subscribe(with: self) { [unowned self] thumb in
                thumb.isSelected = thumb.index.item == selectedIndex
            }
        }

        override func updateLayout() {
            gradientMaskLayer.frame = view.bounds
            let dH = layout.height - scrollView.contentSize.height
            scrollView.contentInset = .init(vertical: max(16, dH / 2))
        }
    }
}
