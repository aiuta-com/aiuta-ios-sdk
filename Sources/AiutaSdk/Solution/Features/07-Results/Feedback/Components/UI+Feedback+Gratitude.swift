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

final class FeedbackGratitudeView: Plane {
    let blur = Blur { it, _ in
        it.style = .dark
    }

    let emoji = Label { it, ds in
        it.font = ds.fonts.gratitudeEmoji
        it.text = "🧡"
    }

    let image = Image { it, ds in
        it.image = ds.icons.gratitude40
        it.contentMode = .scaleAspectFit
    }

    let title = Label { it, ds in
        it.font = ds.fonts.pageTitle
        it.color = .white
        it.isMultiline = true
        it.alignment = .center
    }

    override func setup() {
        emoji.view.isMaxOpaque = !image.hasImage
    }

    override func updateLayout() {
        layout.make { make in
            make.square = 168
            make.centerX = 0
            make.centerY = -25
        }

        blur.layout.make { make in
            make.size = layout.size
            make.shape = ds.shapes.buttonM
        }

        title.layout.make { make in
            make.leftRight = 20
            make.bottom = 20
        }

        emoji.layout.make { make in
            make.centerX = 0
            make.bottom = title.layout.topPin + 23
        }

        image.layout.make { make in
            make.square = 40
            make.center = emoji.layout.center
        }
    }

    convenience init(_ builder: (_ it: FeedbackGratitudeView, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
