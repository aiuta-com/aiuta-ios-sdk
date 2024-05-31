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

final class AiutaTryOnMoreHeaderView: Plane {
    let pin = Image { it, ds in
        it.image = ds.image.sdk(.aiutaDown)
        it.tint = ds.color.gray
        it.view.isMaxOpaque = false
    }

    let title = Label { it, ds in
        it.font = ds.font.header
        it.text = L.generationResultMoreTitle
    }

    var isVisible = true {
        didSet {
            guard isVisible != oldValue else { return }
            updateLayout()
        }
    }
    
    override func setup() {
        view.clipsToBounds = true
    }

    override func updateLayout() {
        layout.make { make in
            make.height = isVisible ? 92 : 0
        }

        pin.layout.make { make in
            make.top = 8
            make.centerX = 0
        }

        title.layout.make { make in
            make.leftRight = 16
            make.top = pin.layout.bottomPin + 32
        }
    }
}
