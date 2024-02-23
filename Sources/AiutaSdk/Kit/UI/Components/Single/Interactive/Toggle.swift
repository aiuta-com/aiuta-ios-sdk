//
//  Created by nGrey on 11.07.2023.
//

import UIKit

class Toggle: Content<UISwitch> {
    var didChange: Signal<Void> {
        view.onValueChanged
    }

    var isOn: Bool {
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

    convenience init(_ builder: (_ it: Toggle, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
