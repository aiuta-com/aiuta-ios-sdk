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

final class AiutaTryOnMoreFooterView: Plane {
    let ground = Gradient { it, ds in
        it.starColor = .black.withAlphaComponent(0)
        it.endColor = .black
        it.view.maxOpacity = 0.6
    }
    
    let pin = Image { it, ds in
        it.image = ds.image.sdk(.aiutaUp)
        it.tint = ds.color.item
    }
    
    let title = Label { it, ds in
        it.font = ds.font.footer
        it.text = L.generationResultSwipeUp
    }
    
    var canBeVisible = false {
        didSet {
            guard oldValue != canBeVisible else { return }
            updateVisibility()
        }
    }
    
    var shouldBeVisible = false {
        didSet {
            guard oldValue != shouldBeVisible else { return }
            updateVisibility()
        }
    }
    
    private func updateVisibility() {
        animations.visibleTo(canBeVisible && shouldBeVisible)
    }
    
    override func setup() {
        view.isVisible = false
    }
    
    override func updateLayout() {
        layout.make { make in
            make.width = layout.boundary.width
            make.height = 82
            make.bottom = 0
        }
        
        ground.layout.make { make in
            make.size = layout.size
        }
        
        pin.layout.make { make in
            make.top = 16
            make.centerX = 0
        }
        
        title.layout.make { make in
            make.top = pin.layout.bottomPin + 13
            make.centerX = 0
        }
    }
}
