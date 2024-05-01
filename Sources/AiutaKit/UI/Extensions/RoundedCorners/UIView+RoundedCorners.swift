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
