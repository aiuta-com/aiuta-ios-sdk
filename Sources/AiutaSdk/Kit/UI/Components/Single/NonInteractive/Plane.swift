//
// Created by nGrey on 04.02.2023.
//

import UIKit
import Resolver

class Plane: Content<PlainView> {
    convenience init(_ builder: (_ it: Plane, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
