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

final class AiutaPhotoSelectorBulletin: PlainBulletin {
    let takeNewPhoto = AiutaPhotoInputButton { it, ds in
        it.icon.image = ds.image.sdk(.aiutaIconCamera)
        it.title.text = "Take a photo"
    }

    let chooseFromLibrary = AiutaPhotoInputButton { it, ds in
        it.icon.image = ds.image.sdk(.aiutaIconGallery)
        it.title.text = "Choose from library"
    }

    var buttons: [AiutaPhotoInputButton] {
        findChildren()
    }

    override func setup() {
        maxWidth = 600
        view.backgroundColor = ds.color.item
        let lastIndex = buttons.count - 1
        buttons.indexed.forEach { i, button in
            button.divider.view.isVisible = i < lastIndex
        }
    }

    override func updateLayout() {
        var height: CGFloat = 0
        buttons.indexed.forEach { _, button in
            button.layout.make { $0.top = height }
            height = button.layout.bottomPin
        }

        layout.make { $0.height = height }
    }
}

final class AiutaPhotoInputButton: PlainButton {
    let icon = Image { it, ds in
        it.tint = ds.color.accent
    }

    let title = Label { it, ds in
        it.font = ds.font.menu
    }

    let divider = Stroke { it, ds in
        it.color = ds.color.lightGray
        it.view.isVisible = false
    }

    override func updateLayout() {
        layout.make { make in
            make.leftRight = 0
            make.height = 68
        }

        icon.layout.make { make in
            make.left = 16
            make.centerY = 0
        }

        title.layout.make { make in
            if icon.image.isSome {
                make.left = icon.layout.rightPin + 12
            } else {
                make.left = 16
            }
            make.right = 16
            make.centerY = -1.5
        }

        divider.layout.make { make in
            make.left = title.layout.left
            make.right = title.layout.right
            make.height = 1
            make.bottom = 0
        }
    }

    convenience init(_ builder: (_ it: AiutaPhotoInputButton, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
