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

final class AiutaFeedbackCommentView: Plane {
    let close = LabelButton { it, ds in
        it.font = ds.font.feedbackClose
        it.text = L.feedbackCancel
    }

    let title = Label { it, ds in
        it.font = ds.font.feedbackTitle
        it.isMultiline = true
    }

    let stroke = Stroke { it, ds in
        it.color = ds.color.neutral
    }

    let input = TextInput { it, ds in
        it.font = ds.font.feedbackButton
        it.view.backgroundColor = .clear
    }

    let commitButton = LabelButton { it, ds in
        it.color = ds.color.accent
        it.font = ds.font.buttonBig
        it.text = L.feedbackSend
    }

    override func updateLayout() {
        close.layout.make { make in
            make.right = 4
            make.top = 7
        }

        title.layout.make { make in
            make.left = 17
            make.width = min(layout.width - 34, 336)
            make.top = close.layout.bottomPin + 23
        }

        stroke.layout.make { make in
            make.leftRight = 17
            make.height = 159
            make.radius = 16
            make.top = title.layout.bottomPin + 19
        }

        input.layout.make { make in
            make.leftRight = 24
            make.top = stroke.layout.top + 3
            make.height = stroke.layout.height - 6
        }

        commitButton.layout.make { make in
            make.leftRight = 16
            make.height = 50
            make.radius = 8
            make.bottom = layout.keyboard.height + 16
        }
    }
}
