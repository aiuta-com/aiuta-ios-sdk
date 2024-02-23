//
//  Created by nGrey on 23.06.2023.
//

import UIKit

extension UIView {
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
