//
//  Created by nGrey on 23.06.2023.
//

import UIKit

extension UIBezierPath {
    convenience init(roundedRect rect: CGRect, withCorners corners: RoundedCorners) {
        self.init()

        let topLeftRadius: CGSize = CGSize(width: corners.topLeft, height: corners.topLeft)
        let topRightRadius: CGSize = CGSize(width: corners.topRight, height: corners.topRight)
        let bottomLeftRadius: CGSize = CGSize(width: corners.bottomLeft, height: corners.bottomLeft)
        let bottomRightRadius: CGSize = CGSize(width: corners.bottomRight, height: corners.bottomRight)

        let path = CGMutablePath()

        let topLeft = rect.origin
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)

        if topLeftRadius != .zero {
            path.move(to: CGPoint(x: topLeft.x + topLeftRadius.width, y: topLeft.y))
        } else {
            path.move(to: topLeft)
        }

        if topRightRadius != .zero {
            path.addLine(to: CGPoint(x: topRight.x - topRightRadius.width, y: topRight.y))
            path.addCurve(to: CGPoint(x: topRight.x, y: topRight.y + topRightRadius.height),
                          control1: CGPoint(x: topRight.x, y: topRight.y),
                          control2: CGPoint(x: topRight.x, y: topRight.y + topRightRadius.height))
        } else {
            path.addLine(to: topRight)
        }

        if bottomRightRadius != .zero {
            path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - bottomRightRadius.height))
            path.addCurve(to: CGPoint(x: bottomRight.x - bottomRightRadius.width, y: bottomRight.y),
                          control1: CGPoint(x: bottomRight.x, y: bottomRight.y),
                          control2: CGPoint(x: bottomRight.x - bottomRightRadius.width, y: bottomRight.y))
        } else {
            path.addLine(to: bottomRight)
        }

        if bottomLeftRadius != .zero {
            path.addLine(to: CGPoint(x: bottomLeft.x + bottomLeftRadius.width, y: bottomLeft.y))
            path.addCurve(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y - bottomLeftRadius.height),
                          control1: CGPoint(x: bottomLeft.x, y: bottomLeft.y),
                          control2: CGPoint(x: bottomLeft.x, y: bottomLeft.y - bottomLeftRadius.height))
        } else {
            path.addLine(to: bottomLeft)
        }

        if topLeftRadius != .zero {
            path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + topLeftRadius.height))
            path.addCurve(to: CGPoint(x: topLeft.x + topLeftRadius.width, y: topLeft.y),
                          control1: CGPoint(x: topLeft.x, y: topLeft.y),
                          control2: CGPoint(x: topLeft.x + topLeftRadius.width, y: topLeft.y))
        } else {
            path.addLine(to: topLeft)
        }

        path.closeSubpath()
        cgPath = path
    }
}
