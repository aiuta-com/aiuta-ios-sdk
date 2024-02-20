//
// Created by nGrey on 03.02.2023.
//

import Foundation

public extension CGPoint {
    func angle(toPoint point: CGPoint) -> CGFloat {
        let originX = point.x - x
        let originY = point.y - y
        var radians = atan2(originY, originX) - 1.5 * .pi

        while radians < 0 {
            radians += CGFloat(2) * .pi
        }

        return radians * 180 / .pi
    }

    func distance(toPoint point: CGPoint) -> CGFloat {
        let deltaX = point.x - x
        let deltaY = point.y - y
        return sqrt(deltaX * deltaX + deltaY * deltaY)
    }

    func offset(x: CGFloat = 0, y: CGFloat = 0) -> CGPoint {
        CGPoint(x: self.x + x, y: self.y + y)
    }
}

public extension CGPoint {
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        CGPoint(x: left.x + right.x, y: left.y + right.y)
    }

    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        CGPoint(x: left.x - right.x, y: left.y - right.y)
    }

    static func * (left: CGPoint, right: CGPoint) -> CGPoint {
        CGPoint(x: left.x * right.x, y: left.y * right.y)
    }

    static func * (left: CGPoint, right: CGFloat) -> CGPoint {
        CGPoint(x: left.x * right, y: left.y * right)
    }

    static func / (left: CGPoint, right: CGFloat) -> CGPoint {
        CGPoint(x: left.x / right, y: left.y / right)
    }
    
    static func * (left: CGPoint, right: CGSize) -> CGPoint {
        CGPoint(x: left.x * right.width, y: left.y * right.width)
    }
    
    static func / (left: CGPoint, right: CGSize) -> CGPoint {
        CGPoint(x: left.x / right.width, y: left.y / right.width)
    }
}
