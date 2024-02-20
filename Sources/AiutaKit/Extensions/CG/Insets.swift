//
// Created by nGrey on 03.02.2023.
//

import UIKit

public extension UIEdgeInsets {
    var horizontalInsetsSum: CGFloat { left + right }
    var verticalInsetsSum: CGFloat { top + bottom }
    var insetsSum: CGSize {
        CGSize(width: horizontalInsetsSum, height: verticalInsetsSum)
    }

    init(inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }

    init(left: CGFloat, right: CGFloat) {
        self.init(top: 0, left: left, bottom: 0, right: right)
    }

    init(top: CGFloat, bottom: CGFloat) {
        self.init(top: top, left: 0, bottom: bottom, right: 0)
    }

    init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }

    static prefix func - (insets: UIEdgeInsets) -> UIEdgeInsets {
        UIEdgeInsets(top: -insets.top,
                     left: -insets.left,
                     bottom: -insets.bottom,
                     right: -insets.right)
    }

    static func * (_ a: UIEdgeInsets, _ b: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: a.top * b,
                     left: a.left * b,
                     bottom: a.bottom * b,
                     right: a.right * b)
    }

    static func - (_ a: UIEdgeInsets, _ b: UIEdgeInsets) -> UIEdgeInsets {
        UIEdgeInsets(top: a.top - b.top,
                     left: a.left - b.left,
                     bottom: a.bottom - b.bottom,
                     right: a.right - b.right)
    }
}
