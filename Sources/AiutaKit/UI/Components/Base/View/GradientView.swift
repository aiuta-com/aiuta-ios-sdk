//
//  Created by nGrey on 26.05.2023.
//

import UIKit

public final class GradientView: UIView {
    public var startColor: UIColor = .red
    public var endColor: UIColor = .blue

    public var colors: [CGColor]?

    public var startPoint: CGPoint = .init(x: 0.5, y: 0)
    public var endPoint: CGPoint = .init(x: 0.5, y: 1)

    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    var gradientLayer: CAGradientLayer {
        layer as! CAGradientLayer
    }

    override public func layoutSubviews() {
        gradientLayer.colors = colors ?? [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        updateShapeWithRoundedCorners()
    }
}
