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

import AiutaKit
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

    var isActionAvailable = true {
        didSet {
            header.action.view.isMaxOpaque = isActionAvailable
            header.action.view.isUserInteractionEnabled = isActionAvailable
        }
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
    }

    let logo = Image { it, ds in
        it.image = ds.image.sdk(.aiutaLogo)
        it.transitions.reference = ds.transition.sdk(.aiutaLogo)
    }

    let title = Label { it, ds in
        it.font = ds.font.navBar
    }

    let action = LabelButton { it, ds in
        it.font = ds.font.navAction
        it.view.minOpacity = 0.5
    }

    override func updateLayout() {
        back.layout.make { make in
            make.left = 0
            make.centerY = 0
        }

        logo.layout.make { make in
            make.centerX = 0
            make.centerY = -6
        }

        title.layout.make { make in
            make.centerX = 0
            make.centerY = -2
        }

        action.layout.make { make in
            make.right = -2
            make.centerY = 0
        }
    }
}
