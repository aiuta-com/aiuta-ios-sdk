//
// Created by nGrey on 02.02.2023.
//

import Foundation

public extension Int {
    func roll(_ count: Int) -> Int {
        if count <= 0 { return 0 }
        let mod = self % count
        return mod >= 0 ? mod : mod + count
    }
}

public extension BinaryInteger {
    var isEven: Bool { isMultiple(of: 2) }
    var isOdd: Bool { !isEven }
}

public extension FloatingPoint {
    var radians: Self {
        self * .pi / 180
    }

    var degrees: Self {
        self * 180 / .pi
    }
}

public extension Bool {
    @inlinable
    var toggled: Bool { !self }
}

public func clamp<T>(_ value: T, min minValue: T, max maxValue: T) -> T where T: Comparable {
    min(max(value, minValue), maxValue)
}
