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

final class AiutaTryOnButton: PlainButton {
    let labelWithIcon = LabelWithIcon()
    
    var label: Label { labelWithIcon.label }
    var icon: Image { labelWithIcon.icon }

    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }

    var font: FontRef? {
        get { label.font }
        set {
            label.font = newValue
            icon.tint = newValue?.color ?? .white
        }
    }

    var color: UIColor? {
        get { view.backgroundColor }
        set { view.backgroundColor = newValue }
    }

    override func updateLayout() {
        labelWithIcon.layout.make { make in
            make.centerX = -2
            make.centerY = -1
        }
    }

    convenience init(_ builder: (_ it: AiutaTryOnButton, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}

final class LabelWithIcon: Plane {
    public let icon = Image()
    public let label = Label()
    
    override func updateLayout() {
        layout.make { make in
            make.height = max(icon.layout.height, label.layout.height)
            make.width = icon.layout.width + label.layout.width + 4
        }
        
        icon.layout.make { make in
            make.left = 0
            make.centerY = 0
        }
        
        label.layout.make { make in
            make.right = 0
            make.centerY = 0
        }
    }
}
