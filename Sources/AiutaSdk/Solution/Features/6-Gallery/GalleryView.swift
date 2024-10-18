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

final class GalleryView: Pager<ImageSource, GalleryPage> {
    let close = ImageButton { it, ds in
        it.image = ds.image.navigation(.close)
        it.tint = .white
    }
    
    let share = LabelButton { it, ds in
        it.font = ds.font.buttonS
        it.label.color = .white
        it.text = L.share
    }

    override func setup() {
        gallerySpace = 20
        view.backgroundColor = .black
    }

    override func updateLayout() {
        close.layout.make { make in
            make.top = max(layout.safe.insets.top, 10) - 10
            make.left = 2
        }
        
        share.layout.make { make in
            make.centerY = close.layout.centerY
            make.right = 16
        }
    }
}
