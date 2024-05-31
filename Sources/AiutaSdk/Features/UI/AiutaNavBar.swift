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

final class AiutaNavBar: Plane {
    let blur = Blur { it, _ in
        it.style = .extraLight
    }

    let header = AiutaNavHeader()

    let stroke = Stroke { it, ds in
        it.color = ds.color.gray.withAlphaComponent(0.5)
    }

    var onDismiss: Signal<Void> {
        header.back.onTouchUpInside
    }

    var isActionEnabled = true {
        didSet {
            updateAction()
        }
    }

    var isActionAvailable = true {
        didSet {
            updateAction()
        }
    }

    var isMinimal = false {
        didSet {
            guard oldValue != isMinimal else { return }
            blur.view.isVisible = !isMinimal
            stroke.view.isVisible = !isMinimal
            if isMinimal {
                isActionAvailable = false
                header.title.view.isVisible = false
                header.logo.view.isVisible = false
                header.logo.transitions.isActive = false
                header.logo.transitions.isReferenceActive = false
            }
        }
    }

    private func updateAction() {
        header.action.view.isVisible = isActionEnabled
        header.action.view.isMaxOpaque = isActionAvailable
        header.action.view.isUserInteractionEnabled = isActionAvailable && isActionEnabled
    }

    override func updateLayout() {
        header.layout.make { make in
            make.top = layout.safe.insets.top + 8
            make.width = layout.boundary.width
            make.height = 44
        }

        layout.make { make in
            make.width = layout.boundary.width
            make.height = header.layout.bottomPin
        }

        blur.layout.make { make in
            make.size = layout.size
        }

        stroke.layout.make { make in
            make.width = layout.width
            make.height = 0.5
            make.bottom = 0
        }
    }

    convenience init(_ builder: (_ it: AiutaNavBar, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}

final class AiutaNavHeader: Plane {
    let back = ImageButton { it, ds in
        it.image = ds.image.sdk(.aiutaBack)
        it.tint = ds.config.appearance.navigationBar.foregroundColor ?? .black
        it.transitions.reference = ds.transition.sdk(.navBack)
    }

    let logo = Image { it, ds in
        it.image = ds.config.appearance.navigationBar.logoImage
        it.transitions.reference = ds.transition.sdk(.aiutaLogo)
        it.transitions.make { make in
            make.opacity = 0
        }
    }

    let title = Label { it, ds in
        it.font = ds.font.navBar
        it.color = ds.config.appearance.navigationBar.foregroundColor ?? .black
    }

    let action = LabelButton { it, ds in
        it.font = ds.font.navAction
        it.label.color = ds.config.appearance.navigationBar.foregroundColor ?? .black
        it.view.minOpacity = 0.5
    }

    override func updateLayout() {
        back.layout.make { make in
            make.left = 0
            make.centerY = 0
        }

        title.layout.make { make in
            make.centerX = 0
            make.centerY = -2
        }

        action.layout.make { make in
            make.right = -2
            make.centerY = 0
        }

        logo.layout.make { make in
            make.centerX = 0
            make.centerY = (ds.config.appearance.navigationBar.logoImage).isSome ? action.layout.centerY + 1 : -6
        }
    }
}
