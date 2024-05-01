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

@_spi(Aiuta) public extension UIView {
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

@_spi(Aiuta) public extension UIView {
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
