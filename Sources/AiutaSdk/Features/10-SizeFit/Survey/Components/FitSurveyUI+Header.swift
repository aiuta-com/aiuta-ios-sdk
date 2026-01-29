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
        let title = Label { it, ds in
            it.font = ds.fonts.titleM
            it.color = ds.colors.primary
        }

        var isSmall = false {
            didSet {
                guard oldValue != isSmall else { return }
                title.font = isSmall ? ds.fonts.pageTitle : ds.fonts.titleM
                updateLayout()
            }
        }

        var text: String? {
            get { title.text }
            set { title.text = newValue }
        }

        override func updateLayout() {
            layout.make { make in
                make.leftRight = 0
            }

            title.layout.make { make in
                if isSmall {
                    make.top = 12
                    make.left = 20
                } else {
                    make.centerX = 0
                    make.top = 60
                }
            }

            layout.make { make in
                make.height = title.layout.bottomPin + 8
            }
        }

        convenience init(_ builder: (_ it: Header, _ ds: DesignSystem) -> Void) {
            self.init()
            builder(self, ds)
        }
    }
}
