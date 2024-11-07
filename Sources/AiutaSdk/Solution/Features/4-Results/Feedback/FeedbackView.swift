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

@available(iOS 13.0.0, *)
extension ResultPage {
    final class FeedbackView: Plane {
        let like = RoundButton { it, ds in
            it.icon.image = ds.image.icon36(.like)
        }

        let dislike = RoundButton { it, ds in
            it.icon.image = ds.image.icon36(.dislike)
        }

        override func updateLayout() {
            dislike.layout.make { make in
                make.left = like.layout.rightPin - 8
            }

            layout.make { make in
                make.width = dislike.layout.rightPin
                make.height = dislike.layout.bottomPin
            }
        }
    }
}