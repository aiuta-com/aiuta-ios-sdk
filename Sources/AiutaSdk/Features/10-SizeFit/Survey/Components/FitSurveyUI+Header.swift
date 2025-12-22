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
    final class Header: Plane {
        let gradient = Gradient { it, _ in
            it.colorStops = [
                .init(UIColor(red: 0.421, green: 0.907, blue: 0.687, alpha: 1), 0.34),
                .init(UIColor(red: 0.272, green: 0.895, blue: 0.917, alpha: 1), 1),
            ]
            it.direction = .horizontal
        }

        let icon = Image { it, ds in
            it.isAutoSize = false
            it.source = ds.icons.sizeFit24
            it.tint = ds.colors.primary
        }

        let title = Label { it, ds in
            it.font = ds.fonts.titleL
            it.color = ds.colors.primary
            it.text = "Find your size"
        }

        override func updateLayout() {
            layout.make { make in
                make.leftRight = 0
            }
            
            gradient.layout.make { make in
                make.circle = 52
                make.centerX = 0
                make.top = 20
            }

            icon.layout.make { make in
                make.square = 26
                make.center = gradient.layout.center
            }

            title.layout.make { make in
                make.centerX = 0
                make.top = gradient.layout.bottomPin + 20
            }
            
            layout.make { make in
                make.height = title.layout.bottomPin + 4
            }
        }
    }
}
