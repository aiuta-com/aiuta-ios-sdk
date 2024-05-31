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

final class AiutaPoweredButton: PlainButton {
    let poweredBy = Label { it, ds in
        it.font = ds.font.poweredBy
        it.color = .black
        it.text = L.poweredBy
    }

    let aiuta = Label { it, ds in
        it.font = ds.font.poweredBy
        it.text = L.aiuta
    }

    override func setup() {
        view.backgroundColor = ds.color.lightGray
    }

    override func updateLayout() {
        poweredBy.layout.make { make in
            make.top = 8
            make.left = 12
        }

        aiuta.layout.make { make in
            make.top = poweredBy.layout.top
            make.left = poweredBy.layout.rightPin + 4
        }

        layout.make { make in
            make.width = aiuta.layout.rightPin + poweredBy.layout.left
            make.height = poweredBy.layout.bottomPin + poweredBy.layout.top
            make.radius = make.height / 2
        }
    }
}
