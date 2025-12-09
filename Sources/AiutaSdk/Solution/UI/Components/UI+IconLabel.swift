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

final class LabelWithIcon: Plane {
    public let icon = Image { it, ds in
        it.image = ds.icons.magic20
        it.tint = ds.colors.onDark
    }

    public let label = Label { it, ds in
        it.font = ds.fonts.buttonM
        it.color = ds.colors.onDark
        it.text = ds.strings.tryOn
        it.isLineHeightMultipleEnabled = false
    }

    override func updateLayout() {
        layout.make { make in
            make.height = max(20, label.layout.height)
            if icon.image.isSome {
                make.width = icon.layout.width + label.layout.width + 4
            } else {
                make.width = label.layout.width
            }
        }

        icon.layout.make { make in
            make.square = 20
            make.left = 0
            make.centerY = 0
        }

        label.layout.make { make in
            make.right = 0
            make.centerY = 0
        }
    }
}
