//
// Created by nGrey on 04.02.2023.
//

import UIKit
import Resolver

open class Plane: Content<PlainView> {
    public convenience init(_ builder: (_ it: Plane, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
