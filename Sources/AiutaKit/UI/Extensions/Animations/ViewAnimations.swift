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
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        layer.add(animation, forKey: "shake")
    }

    func flip() {
        var perspective = CATransform3DIdentity
        perspective.m34 = 1 / -200
        layer.transform = perspective
        let rotate = CABasicAnimation(keyPath: "transform.rotation.y")
        rotate.fromValue = 0
        rotate.byValue = CGFloat.pi * 2
        rotate.duration = 0.8
        layer.add(rotate, forKey: nil)
    }
    
    func rotate(duration: Double) {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.duration = duration
        rotationAnimation.repeatCount = .infinity
        layer.add(rotationAnimation, forKey: "rotate")
    }
}
