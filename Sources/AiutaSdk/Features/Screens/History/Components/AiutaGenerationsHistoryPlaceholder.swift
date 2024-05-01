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

final class AiutaGenerationsHistoryPlaceholder: Plane {
    let image = Image { it, ds in
        it.tint = 0xEEEEEEFF.uiColor
        it.image = ds.image.sdk(.aiutaEmptyHistory)
    }

    let title = Label { it, ds in
        it.font = ds.font.historyPlaceholder
        it.isMultiline = true
        it.alignment = .center
        it.text = "Once you try on first item your\ntry-on history would be stored here"
    }

    override func updateLayout() {
        layout.make { make in
            make.width = layout.boundary.width
        }

        image.layout.make { make in
            make.centerX = 0
        }

        title.layout.make { make in
            make.leftRight = 16
            make.top = image.layout.bottomPin + 36
        }

        layout.make { make in
            make.height = title.layout.bottomPin
        }
    }
}
