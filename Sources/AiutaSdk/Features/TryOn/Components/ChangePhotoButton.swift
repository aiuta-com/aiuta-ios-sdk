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

extension TryOnView {
    final class ChangePhotoButton: PlainButton {
        let blur = Blur { it, ds in
            it.style = .extraLight
            it.intensity = 0.4
        }
        
        let label = Label { it, ds in
            it.isLineHeightMultipleEnabled = false
            it.font = ds.font.buttonS
            it.color = ds.color.primary
            it.text = L.imageSelectorChangeButton
        }
        
        override func updateLayout() {
            layout.make { make in
                make.width = label.layout.width + 48
                make.height = label.layout.height + 24
            }
            
            label.layout.make { make in
                make.center = .zero
            }
            
            blur.layout.make { make in
                make.inset = 0
                make.radius = ds.dimensions.buttonSmallRadius
            }
        }
    }
}
