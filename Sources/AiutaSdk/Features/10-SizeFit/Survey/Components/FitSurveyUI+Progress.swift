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

import AiutaCore
@_spi(Aiuta) import AiutaKit
import UIKit

extension FitSurveyUI {
    final class Progress: Plane {
        var value: CGFloat = 0

        let fill = Stroke { it, ds in
            it.color = ds.colors.primary
        }

        override func setup() {
            view.backgroundColor = ds.colors.neutral
        }

        override func updateLayout() {
            layout.make { make in
                make.width = 124
                make.height = 10
                make.radius = layout.height / 2
            }

            fill.layout.make { make in
                make.width = max(layout.width * clamp(value, min: 0, max: 1), 12)
                make.height = layout.height
                make.radius = layout.height / 2
            }
        }
    }
}
