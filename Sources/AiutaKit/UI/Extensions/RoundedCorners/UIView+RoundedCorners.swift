//
//  Created by nGrey on 23.06.2023.
//

import UIKit

public extension UIView {
    private struct Property {
        static var roundedCorners: Void?
        static var shape: Void?
    }

    var roundedCorners: RoundedCorners? {
        get { getAssociatedProperty(&Property.roundedCorners, ofType: RoundedCorners.self) }
        set {
            if cornerRadius != 0 { cornerRadius = 0 }
            setAssociatedProperty(&Property.roundedCorners, newValue: newValue)
            updateShapeWithRoundedCorners()
        }
    }

    var shape: CAShapeLayer? {
        get { getAssociatedProperty(&Property.shape, ofType: CAShapeLayer.self) }
        set { setAssociatedProperty(&Property.shape, newValue: newValue) }
    }

    func updateShapeWithRoundedCorners() {
        guard let roundedCorners else {
            if shape.isSome { layer.mask = nil }
            return
        }
        if shape.isNil { shape = CAShapeLayer() }
        guard let shape else { return }
        let path = UIBezierPath(roundedRect: bounds, withCorners: roundedCorners)
        shape.path = path.cgPath
        layer.mask = shape
        layer.masksToBounds = true
    }
}
