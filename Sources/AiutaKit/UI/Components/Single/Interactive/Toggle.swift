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

import UIKit

@_spi(Aiuta) open class Toggle: Content<UISwitch> {
    public var didChange: Signal<Void> {
        view.onValueChanged
    }

    public var isOn: Bool {
        get { view.isOn }
        set {
            guard newValue != isOn else { return }
            view.isOn = newValue
        }
    }

    override func setupInternal() {
        view.tintColor = 0x666666FF.uiColor
        view.onTintColor = ds.color.accent
    }

    public convenience init(_ builder: (_ it: Toggle, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
