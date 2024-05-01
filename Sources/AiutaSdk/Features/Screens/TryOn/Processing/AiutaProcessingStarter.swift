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

final class AiutaProcessingStarter: Plane {
    let blur = Blur { it, _ in
        it.style = .extraLight
    }

    let go = LabelButton { it, ds in
        it.font = ds.font.button
        it.color = ds.color.accent
        it.text = "Try on"
    }

    override func updateLayout() {
        layout.make { make in
            make.width = layout.boundary.width
            make.height = layout.safe.insets.bottom + 72
            make.bottom = 0
        }

        go.layout.make { make in
            make.leftRight = 16
            make.top = 10
            make.height = 50
            make.radius = 8
        }

        blur.layout.make { make in
            make.inset = 0
        }
    }
}
