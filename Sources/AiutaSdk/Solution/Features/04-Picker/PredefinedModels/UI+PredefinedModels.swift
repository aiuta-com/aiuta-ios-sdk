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

final class PredefinedModelsView: Plane {
    let navBar = NavBar { it, ds in
        it.style = .backTitleAction
        it.title = ds.strings.predefinedModelsTitle
    }

    let preview = Image { it, ds in
        it.contentMode = .scaleAspectFill
        it.desiredQuality = .hiResImage
        it.isAutoSize = false
        it.view.backgroundColor = ds.colors.neutral
    }

    let categorySelector = PredefinedCategorySelector()

    let magnifier = PredefinedModelsMagnifier()

    let tryOnButton = TryOnButton { it, _ in
        it.view.isVisible = false
    }

    let errorIcon = Image { it, ds in
        it.image = ds.icons.error36
        it.tint = ds.colors.primary
        it.view.isVisible = false
    }

    let errorLabel = Label { it, ds in
        it.font = ds.fonts.regular
        it.color = ds.colors.primary
        it.text = ds.strings.predefinedModelsEmptyListError
        it.view.isVisible = false
    }

    func showEmptyState() {
        preview.animations.visibleTo(false)
        categorySelector.animations.visibleTo(false)
        magnifier.animations.visibleTo(false)
        tryOnButton.animations.visibleTo(false)
        errorIcon.animations.visibleTo(true)
        errorLabel.animations.visibleTo(true)
    }

    override func setup() {
        magnifier.onSelect.subscribe(with: self) { [unowned self] image in
            preview.source = image
            preview.crossDissolveChanges = false
        }
    }

    override func updateLayout() {
        tryOnButton.layout.make { make in
            make.leftRight = 16
            make.height = 50
            make.shape = ds.shapes.buttonM
            make.bottom = layout.safe.insets.bottom + 12
        }

        magnifier.layout.make { make in
            make.leftRight = 0
            make.height = 164
            make.bottom = tryOnButton.layout.topPin
        }

        categorySelector.layout.make { make in
            make.bottom = magnifier.layout.topPin
        }

        preview.layout.make { make in
            make.top = navBar.layout.bottomPin + 16
            make.bottom = categorySelector.layout.topPin + 16
            make.leftRight = 65
            make.shape = ds.shapes.imageL
        }

        errorIcon.layout.make { make in
            make.square = 60
            make.center = .zero
        }

        errorLabel.layout.make { make in
            make.centerX = 0
            make.top = errorIcon.layout.bottomPin + 8
        }
    }
}
