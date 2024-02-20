//
// Created by nGrey on 03.02.2023.
//

import UIKit

extension CGAffineTransform {
    init(scale: CGFloat) {
        self.init(scaleX: scale, y: scale)
    }

    init(rotation: CGFloat) {
        self.init(rotationAngle: rotation.radians)
    }
}

func +(lhs: CGAffineTransform, rhs: CGAffineTransform) -> CGAffineTransform {
    lhs.concatenating(rhs)
}
