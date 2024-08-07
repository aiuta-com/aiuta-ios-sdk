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

final class AiutaFeedbackGratitudeView: Plane {
    let blur = Blur { it, _ in
        it.style = .dark
    }

    let emoji = Label { it, ds in
        it.font = ds.font.feedbackEmoji
        it.text = "🧡"
    }

    let title = Label { it, ds in
        it.font = ds.font.feedbackGratitude
        it.isMultiline = true
        it.alignment = .center
    }

    override func updateLayout() {
        layout.make { make in
            make.square = 168
            make.centerX = 0
            make.centerY = -35
        }

        blur.layout.make { make in
            make.size = layout.size
            make.radius = 24
        }

        title.layout.make { make in
            make.leftRight = 20
            make.bottom = 20
        }

        emoji.layout.make { make in
            make.centerX = 0
            make.bottom = title.layout.topPin + 23
        }
    }

    convenience init(_ builder: (_ it: AiutaFeedbackGratitudeView, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
