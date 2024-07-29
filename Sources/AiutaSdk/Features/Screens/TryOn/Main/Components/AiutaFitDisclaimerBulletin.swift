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

final class AiutaFitDisclaimerBulletin: PlainBulletin {
    let label = Label { it, ds in
        it.font = ds.font.disclaimerText
        it.isMultiline = true
    }

    override func setup() {
        maxWidth = 600
        view.backgroundColor = ds.color.item
    }

    override func updateLayout() {
        label.layout.make { make in
            make.leftRight = 16
            make.top = 18
        }

        layout.make { make in
            make.height = label.layout.bottomPin + 30
        }
    }

    convenience init(_ builder: (_ it: AiutaFitDisclaimerBulletin, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
