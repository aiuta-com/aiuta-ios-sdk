//
// Created by nGrey on 01.03.2023.
//

import UIKit

class PlainButton: Content<TouchView> {
    var onTouchDown: Signal<Void> { view.onTouchDown }
    var onTouchUp: Signal<Void> { view.onTouchUp }
    var onTouchUpInside: Signal<Void> { view.onTouchUpInside }
    var onLongTouch: Signal<Void> { view.onLongTouch }

    convenience init(_ builder: (_ it: PlainButton, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
