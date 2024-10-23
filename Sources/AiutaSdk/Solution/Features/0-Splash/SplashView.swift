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

final class SplashView: Plane {
    let ground = Image { it, ds in
        it.isAutoSize = false
        it.contentMode = .scaleAspectFill
        it.image = ds.image.splash(.background)
    }

    let closeButton = ImageButton { it, ds in
        it.image = ds.image.navigation(.close)
        it.tint = ds.color.onDark
    }

    let icon = Image { it, ds in
        it.isAutoSize = false
        it.image = ds.image.splash(.icon)
    }

    let title = Label { it, ds in
        it.font = ds.font.titleXL
        it.color = ds.color.onDark
        it.text = L.preOnboardingTitle
        it.alignment = .center
        it.minScale = 0.5
    }

    let subtitle = Label { it, ds in
        it.font = ds.font.welcome
        it.color = ds.color.onDark
        it.isMultiline = true
        it.alignment = .center
        it.text = L.preOnboardingSubtitle
    }

    let startButton = LabelButton { it, ds in
        it.font = ds.font.button
        it.color = ds.color.ground
        it.label.color = ds.color.primary
        it.text = L.preOnboardingButton
    }

    override func setup() {
        view.backgroundColor = ds.color.primary
    }

    override func updateLayout() {
        ground.layout.make { make in
            make.inset = 0
        }

        closeButton.layout.make { make in
            if ds.config.appearance.presentationStyle.isFullScreen {
                make.top = layout.safe.insets.top - 8
            } else {
                make.top = 0
            }
            make.height = 52
            make.width = 48
            make.right = 0
        }

        closeButton.imageView.layout.make { make in
            make.square = 24
            make.center = .zero
        }

        title.layout.make { make in
            make.leftRight = 16
            make.centerY = -10
        }

        icon.layout.make { make in
            make.square = 82
            make.bottom = title.layout.topPin + 8
            make.centerX = 0
        }

        subtitle.layout.make { make in
            make.leftRight = 16
            make.top = title.layout.bottomPin + 16
        }

        startButton.layout.make { make in
            make.leftRight = 24
            make.height = 48
            make.top = subtitle.layout.bottomPin + 35
            make.radius = ds.dimensions.buttonLargeRadius
        }
    }
}
