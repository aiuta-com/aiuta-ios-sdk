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

final class OnBoardingView: Plane {
    let scroll = StickyScroll()

    let navBar = NavBar { it, ds in
        if ds.config.appearance.preferRightClose {
            it.style = .backTitleClose
        } else {
            it.style = .backTitleAction
        }
    }

    let button = LabelButton { it, ds in
        it.font = ds.font.button
        it.color = ds.color.brand
        it.label.color = ds.color.onDark
        it.text = L.next
        it.view.minOpacity = 0.4
    }

    override func updateLayout() {
        scroll.layout.make { make in
            make.leftRight = 0
            make.top = navBar.layout.bottomPin
            make.bottom = 0
        }

        button.layout.make { make in
            make.leftRight = 16
            make.height = 48
            make.radius = ds.dimensions.buttonLargeRadius
            make.bottom = layout.safe.insets.bottom + 10
        }

        scroll.bottomInset = button.layout.topPin
    }
}
