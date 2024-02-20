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

final class AiutaErrorSnackbar: Plane {
    let icon = Image { it, ds in
        it.image = ds.image.sdk(.aiutaError)
        it.tint = .white
    }

    let label = Label { it, ds in
        it.font = ds.font.snackbar
        it.isMultiline = true
        it.text = "Something went wrong.\nPlease try again later"
    }

    let close = ImageButton { it, ds in
        it.image = ds.image.sdk(.aiutaCross)
        it.tint = .white
    }

    override func setup() {
        view.backgroundColor = 0xE52239FF.uiColor
    }

    override func updateLayout() {
        layout.make { make in
            make.height = 68
            make.radius = 16
        }

        icon.layout.make { make in
            make.left = 16
            make.centerY = 0
        }

        close.layout.make { make in
            make.right = 6
            make.centerY = 0
        }

        label.layout.make { make in
            make.left = icon.layout.rightPin + 12
            make.right = close.layout.leftPin + 2
            make.top = 4
            make.bottom = 4
        }
    }
}
