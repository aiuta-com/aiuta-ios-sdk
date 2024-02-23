//
//  Created by nGrey on 26.05.2023.
//

import UIKit

final class GradientView: UIView {
    var startColor: UIColor = .red
    var endColor: UIColor = .blue

    var colors: [CGColor]?

    var startPoint: CGPoint = .init(x: 0.5, y: 0)
    var endPoint: CGPoint = .init(x: 0.5, y: 1)

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }

    override func layoutSubviews() {
        gradientLayer.colors = colors ?? [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        updateShapeWithRoundedCorners()
    }
}
