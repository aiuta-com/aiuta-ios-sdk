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
    final class ThumbnailsBar: Plane {
        let onSelectProduct = Signal<Aiuta.Product>()
        
        var products: Aiuta.Products? {
            didSet {
                view.isVisible = products.isSome
                
                gallery.removeAllContents()
                gallery.scroll(to: -gallery.contentInset.left)

                products?.forEach { product in
                    gallery.addContent(ThumbnailItem()) { it, ds in
                        it.image.source = product.imageUrls.first
                        it.onTouchUpInside.subscribe(with: self) { [unowned self] in
                            onSelectProduct.fire(product)
                        }
                    }
                }
            }
        }

        let title = Label { it, ds in
            it.font = ds.fonts.product
            it.color = ds.colors.primary
            it.text = ds.strings.outfitItemsTitle
        }
        
        let gallery = HScroll { it, _ in
            it.contentInset = .init(horizontal: 0)
            it.itemSpace = 6
        }

        override func updateLayout() {
            layout.make { make in
                make.left = 20
                make.top = 50
                make.width = layout.boundary.width / 2 - 20
                make.height = 57
            }
            
            gallery.layout.make { make in
                make.inset = 0
            }

            title.layout.make { make in
                make.bottom = 67
            }
        }
    }

    final class ThumbnailItem: PlainButton {
        var useExtraInset: Bool = true {
            didSet {
                image.contentMode = useExtraInset ? .scaleAspectFit : .scaleAspectFill
            }
        }
        
        let image = Image { it, _ in
            it.contentMode = .scaleAspectFit
            it.desiredQuality = .thumbnails
            it.isAutoSize = false
        }

        override func setup() {
            view.backgroundColor = ds.colors.neutral
        }

        override func updateLayout() {
            layout.make { make in
                make.width = 54
                make.height = 57
                make.shape = ds.shapes.imageS
            }

            image.layout.make { make in
                if useExtraInset {
                    make.inset = 8
                    make.shape = .rectangular
                } else {
                    make.size = layout.size
                    make.shape = ds.shapes.imageS
                }
            }
        }
    }
}
