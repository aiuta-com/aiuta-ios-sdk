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

@_spi(Aiuta) public extension CGSize {
    init(square: CGFloat) {
        self.init(width: square, height: square)
    }

    static var infinity: CGSize {
        CGSize(width: CGFloat.infinity, height: CGFloat.infinity)
    }

    func almostEqualTo(_ other: CGSize, epsilon: CGFloat = 0.01) -> Bool {
        return abs(width - other.width) < epsilon &&
            abs(height - other.height) < epsilon
    }

    var square: CGFloat {
        width * height
    }
}

@_spi(Aiuta) public extension CGSize {
    func fill(_ other: CGSize?) -> CGSize {
        guard let other else { return self }
        let hScale = other.height / height
        let wScale = other.width / width
        return other / min(hScale, wScale)
    }

    func fit(_ other: CGSize?) -> CGSize {
        guard let other else { return self }
        let hScale = other.height / height
        let wScale = other.width / width
        return other / max(hScale, wScale)
    }
}

@_spi(Aiuta) public extension CGSize {
    var isZero: Bool {
        width == 0 && height == 0
    }

    var isAnyZero: Bool {
        width == 0 || height == 0
    }

    var smallestSide: CGFloat {
        min(width, height)
    }

    var biggestSide: CGFloat {
        max(width, height)
    }

    var center: CGPoint {
        CGPoint(x: width / 2, y: height / 2)
    }

    var ceiled: CGSize {
        CGSize(width: ceil(width), height: ceil(height))
    }

    var aspectRatio: CGFloat {
        width / height
    }
}

@_spi(Aiuta) public extension CGSize {
    static func + (left: CGSize, right: CGSize) -> CGSize {
        CGSize(width: left.width + right.width,
               height: left.height + right.height)
    }

    static func - (left: CGSize, right: CGSize) -> CGSize {
        CGSize(width: left.width - right.width,
               height: left.height - right.height)
    }
}

@_spi(Aiuta) public extension CGSize /* UIEdgeInsets */ {
    static func + (_ left: CGSize, _ right: UIEdgeInsets) -> CGSize {
        CGSize(width: left.width + right.horizontalInsetsSum,
               height: left.height + right.verticalInsetsSum)
    }

    static func - (_ left: CGSize, _ right: UIEdgeInsets) -> CGSize {
        CGSize(width: left.width - right.horizontalInsetsSum,
               height: left.height - right.verticalInsetsSum)
    }
}

@_spi(Aiuta) public extension CGSize /* CGFloat */ {
    static func + (_ left: CGSize, _ right: CGFloat) -> CGSize {
        CGSize(width: left.width + right,
               height: left.height + right)
    }

    static func - (_ left: CGSize, _ right: CGFloat) -> CGSize {
        CGSize(width: left.width - right,
               height: left.height - right)
    }

    static func * (_ left: CGSize, _ right: CGFloat) -> CGSize {
        CGSize(width: left.width * right,
               height: left.height * right)
    }

    static func / (_ left: CGSize, _ right: CGFloat) -> CGSize {
        CGSize(width: left.width / right,
               height: left.height / right)
    }
}

@_spi(Aiuta) extension CGSize {
    @_spi(Aiuta) public static func < (lhs: CGSize, rhs: CGSize) -> Bool {
        lhs.width * lhs.height < rhs.width * rhs.height
    }
    
    @_spi(Aiuta) public static func > (lhs: CGSize, rhs: CGSize) -> Bool {
        lhs.width * lhs.height > rhs.width * rhs.height
    }
}
