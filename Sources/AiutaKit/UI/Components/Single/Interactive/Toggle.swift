//
//  Created by nGrey on 11.07.2023.
//

import UIKit

open class Toggle: Content<UISwitch> {
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
