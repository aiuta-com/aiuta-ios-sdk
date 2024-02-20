//
// Created by nGrey on 03.02.2023.
//

import UIKit

public extension CGRect {
    init(square: CGFloat) {
        self.init(x: 0, y: 0, width: square, height: square)
    }

    init(size: CGSize) {
        self.init(x: 0, y: 0, width: size.width, height: size.height)
    }

    init(width: CGFloat, height: CGFloat) {
        self.init(x: 0, y: 0, width: width, height: height)
    }

    init(width: Int, height: Int) {
        self.init(x: 0, y: 0, width: width, height: height)
    }

    init(x: CGFloat, y: CGFloat, size: CGSize) {
        self.init(x: x, y: y, width: size.width, height: size.height)
    }

    init(x: CGFloat, y: CGFloat, square: CGFloat) {
        self.init(x: x, y: y, width: square, height: square)
    }

    init(origin: CGPoint, width: CGFloat, height: CGFloat) {
        self.init(x: origin.x, y: origin.y, width: width, height: height)
    }

    init(center: CGPoint, size: CGSize) {
        let x = center.x - size.width / 2
        let y = center.y - size.height / 2
        self.init(origin: .init(x: x, y: y), size: size)
    }

    init(center: CGPoint, square: CGFloat) {
        let x = center.x - square / 2
        let y = center.y - square / 2
        self.init(x: round(x), y: round(y), width: round(square), height: round(square))
    }

    init(minX: CGFloat, minY: CGFloat, maxX: CGFloat, maxY: CGFloat) {
        self.init(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
}

public extension CGRect {
    var center: CGPoint { CGPoint(x: midX, y: midY) }

    func containsAny(_ points: [CGPoint]) -> Bool {
        points.first(where: { self.contains($0) }) != nil
    }

    func almostEqual(_ other: CGRect, epsilon: CGFloat) -> Bool {
        abs(other.origin.x - origin.x) < epsilon &&
            abs(other.origin.y - origin.y) < epsilon &&
            abs(other.size.width - size.width) < epsilon &&
            abs(other.size.height - size.height) < epsilon
    }

    func prettyString() -> String {
        String(format: "(%.2f, %.2f; %.2f, %.2f)", origin.x, origin.y, width, height)
    }
}

public extension CGRect {
    func move(by point: CGPoint) -> CGRect {
        CGRect(x: origin.x + point.x, y: origin.y + point.y, size: size)
    }

    func fit(_ other: CGSize?) -> CGRect {
        guard let other else { return self }
        let newSize = size.fit(other)
        return CGRect(x: minX + (size.width - newSize.width) / 2,
                      y: minY + (size.height - newSize.height) / 2,
                      size: newSize)
    }

    func fill(_ other: CGSize?) -> CGRect {
        guard let other else { return self }
        let newSize = size.fill(other)
        return CGRect(x: minX + (size.width - newSize.width) / 2,
                      y: minY + (size.height - newSize.height) / 2,
                      size: newSize)
    }
}

public extension CGRect /* UIEdgeInsets */ {
    static func + (_ left: CGRect, _ right: UIEdgeInsets) -> CGRect {
        CGRect(x: left.origin.x - right.left,
               y: left.origin.y - right.top,
               width: left.width + right.horizontalInsetsSum,
               height: left.height + right.verticalInsetsSum)
    }

    static func - (_ left: CGRect, _ right: UIEdgeInsets) -> CGRect {
        CGRect(x: left.origin.x + right.left,
               y: left.origin.y + right.top,
               width: left.width - right.horizontalInsetsSum,
               height: left.height - right.verticalInsetsSum)
    }
}

public extension CGRect /* CGSize */ {
    static func * (_ left: CGRect, _ right: CGSize) -> CGRect {
        CGRect(x: left.origin.x * right.width,
               y: left.origin.y * right.height,
               width: left.width * right.width,
               height: left.height * right.height)
    }

    static func / (_ left: CGRect, _ right: CGSize) -> CGRect {
        CGRect(x: left.origin.x / right.width,
               y: left.origin.y / right.height,
               width: left.width / right.width,
               height: left.height / right.height)
    }
}

public extension CGRect /* CGFloat */ {
    static func + (_ left: CGRect, _ right: CGFloat) -> CGRect {
        CGRect(x: left.origin.x - right / 2,
               y: left.origin.y - right / 2,
               width: left.width + right,
               height: left.height + right)
    }

    static func - (_ left: CGRect, _ right: CGFloat) -> CGRect {
        CGRect(x: left.origin.x + right / 2,
               y: left.origin.y + right / 2,
               width: left.width - right,
               height: left.height - right)
    }

    static func * (_ left: CGRect, _ right: CGFloat) -> CGRect {
        CGRect(x: left.origin.x * right,
               y: left.origin.y * right,
               width: left.width * right,
               height: left.height * right)
    }

    static func / (_ left: CGRect, _ right: CGFloat) -> CGRect {
        CGRect(x: left.origin.x / right,
               y: left.origin.y / right,
               width: left.width / right,
               height: left.height / right)
    }
}
