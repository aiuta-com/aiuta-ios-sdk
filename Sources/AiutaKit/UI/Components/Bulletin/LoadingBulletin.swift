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

@_spi(Aiuta) public final class LoadingBulletin: PlainBulletin {
    let spinner = Spinner { it, ds in
        it.view.color = ds.kit.item
    }

    private var hasSpinner = true

    override public func setup() {
        behaviour = .fullscreen
        hasStroke = false

        spinner.view.opacity = 0
        if hasSpinner {
            spinner.animations.opacityTo(1, delay: .oneSecond)
        }
    }

    public func showSpinner(delay: AsyncDelayTime = .instant) {
        spinner.animations.opacityTo(1, delay: delay)
    }

    public func hideSpinner(duration: AsyncDelayTime) {
        switch duration {
            case .instant: spinner.view.opacity = 0
            default: spinner.animations.opacityTo(0, time: duration)
        }
    }

    override public func updateLayout() {
        layout.make { make in
            make.width = layout.screen.width
            make.height = layout.screen.height - layout.safe.insets.top - 48
        }

        spinner.layout.make { make in
            make.centerX = 0
            make.centerY = -48
        }
    }

    public convenience init(empty: Bool, isDismissable: Bool = false) {
        self.init()
        hasSpinner = !empty
        isDismissableByPan = isDismissable
    }
}
