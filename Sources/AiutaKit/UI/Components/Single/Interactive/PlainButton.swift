//
// Created by nGrey on 01.03.2023.
//

import UIKit

open class PlainButton: Content<TouchView> {
    public var onTouchDown: Signal<Void> { view.onTouchDown }
    public var onTouchUp: Signal<Void> { view.onTouchUp }
    public var onTouchUpInside: Signal<Void> { view.onTouchUpInside }
    public var onLongTouch: Signal<Void> { view.onLongTouch }

    public convenience init(_ builder: (_ it: PlainButton, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
