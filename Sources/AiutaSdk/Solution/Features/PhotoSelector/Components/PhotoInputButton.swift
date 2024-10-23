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

extension PhotoSelectorBulletin {
    final class PhotoInputButton: PlainButton {
        let icon = Image { it, ds in
            it.isAutoSize = false
            it.tint = ds.color.brand
        }

        let title = Label { it, ds in
            it.font = ds.font.cells
            it.color = ds.color.primary
        }

        let divider = Stroke { it, ds in
            it.color = ds.color.neutral2
            it.view.isVisible = false
        }

        override func updateLayout() {
            layout.make { make in
                make.leftRight = 0
                make.height = 72
            }

            icon.layout.make { make in
                make.square = 24
                make.left = 16
                make.centerY = 0
            }

            title.layout.make { make in
                if icon.image.isSome {
                    make.left = icon.layout.rightPin + 16
                } else {
                    make.left = 16
                }
                make.right = 16
                make.centerY = 0
            }

            divider.layout.make { make in
                make.left = title.layout.left
                make.right = ds.dimensions.continuingSeparators ? 0 : title.layout.right
                make.height = 1
                make.bottom = 0
            }
        }

        convenience init(_ builder: (_ it: PhotoInputButton, _ ds: DesignSystem) -> Void) {
            self.init()
            builder(self, ds)
        }
    }
}
