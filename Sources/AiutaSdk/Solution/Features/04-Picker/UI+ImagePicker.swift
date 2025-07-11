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

final class PhotoSelectorBulletin: PlainBulletin {
    let takeNewPhoto = PhotoInputButton { it, ds in
        it.icon.image = ds.icons.camera24
        it.title.text = ds.strings.cameraButtonTakePhoto
    }

    let chooseFromLibrary = PhotoInputButton { it, ds in
        it.icon.image = ds.icons.gallery24
        it.title.text = ds.strings.galleryButtonSelectPhoto
    }

    let selectPredefindeModel = PhotoInputButton { it, ds in
        it.icon.image = ds.icons.selectModels24
        it.title.text = ds.strings.predefinedModelsTitle
    }

    var buttons: [PhotoInputButton] {
        findChildren().filter { $0.view.isVisible }
    }

    override func setup() {
        maxWidth = 600
        strokeWidth = ds.shapes.grabberWidth
        strokeOffset = ds.shapes.grabberOffset
        cornerRadius = ds.shapes.bottomSheet.radius
        view.backgroundColor = ds.colors.background

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

        layout.make { $0.height = height + 16 }
    }
}
