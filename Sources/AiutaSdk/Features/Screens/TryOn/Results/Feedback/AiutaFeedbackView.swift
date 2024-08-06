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

final class AiutaFeedbackView: Shadow {
    let like = ImageButton { it, ds in
        it.image = ds.image.sdk(.aiutaLike)
    }

    let dislike = ImageButton { it, ds in
        it.image = ds.image.sdk(.aiutaDislike)
    }

    override func setup() {
        shadowColor = .black
        shadowOpacity = 0.2
        shadowRadius = 28
        shadowOffset = CGSize(width: 0, height: 8)
        color = .black.withAlphaComponent(0.12)
    }

    override func updateLayout() {
        layout.make { make in
            make.width = 100
            make.height = 40
            make.radius = 20
        }

        like.layout.make { make in
            make.centerY = 0
            make.right = -2
        }

        dislike.layout.make { make in
            make.centerY = 0
            make.left = -2
        }
    }
}
