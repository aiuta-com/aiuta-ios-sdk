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

@_spi(Aiuta) public extension UIEdgeInsets {
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
