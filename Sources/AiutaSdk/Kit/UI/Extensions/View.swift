//
// Created by nGrey on 02.02.2023.
//

import UIKit

extension UIView {
    private struct Property {
        static var minOpacity: CGFloat = 0
        static var maxOpacity: CGFloat = 1
        static var backgroundColorHex: Int64 = 0x0
        static var transitionRef: Void?
    }

    var isVisible: Bool {
        get { !isHidden && isMaxOpaque }
        set {
            isHidden = !newValue
            isMaxOpaque = newValue
        }
    }

    var opacity: CGFloat {
        get { alpha }
        set { alpha = newValue }
    }

    var minOpacity: CGFloat {
        get { getAssociatedProperty(&Property.minOpacity, defaultValue: Property.minOpacity) }
        set {
            setAssociatedProperty(&Property.minOpacity, newValue: newValue)
            if opacity < newValue { opacity = newValue }
        }
    }

    var isMinOpaque: Bool {
        get { opacity <= minOpacity }
        set { opacity = newValue ? minOpacity : maxOpacity }
    }

    var maxOpacity: CGFloat {
        get { getAssociatedProperty(&Property.maxOpacity, defaultValue: Property.maxOpacity) }
        set {
            setAssociatedProperty(&Property.maxOpacity, newValue: newValue)
            if opacity > newValue { opacity = newValue }
        }
    }

    var isMaxOpaque: Bool {
        get { opacity >= maxOpacity }
        set { opacity = newValue ? maxOpacity : minOpacity }
    }

    var borderWidth: CGFloat {
        get { layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set { layer.borderColor = newValue?.cgColor }
    }

    var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            if roundedCorners.isSome { roundedCorners = nil }
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }

    @available(iOS 13.0, *)
    var cornerCurve: CALayerCornerCurve {
        get { layer.cornerCurve }
        set { layer.cornerCurve = newValue }
    }

    var size: CGSize { bounds.size }

    var masksToBounds: Bool {
        get { layer.masksToBounds }
        set {
            clipsToBounds = newValue
            layer.masksToBounds = newValue
        }
    }
}

extension UIView {
    func make(_ closure: (_ make: UIView) -> Void) {
        closure(self)
    }

    func rotate(byDegrees angle: CGFloat) {
        transform = transform.rotated(by: angle.radians)
    }

    func rotate(toDegrees angle: CGFloat) {
        transform = CGAffineTransformMakeRotation(angle.radians)
    }
}
