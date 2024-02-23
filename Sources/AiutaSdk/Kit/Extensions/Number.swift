//
// Created by nGrey on 02.02.2023.
//

import Foundation

extension Int {
    func roll(_ count: Int) -> Int {
        if count <= 0 { return 0 }
        let mod = self % count
        return mod >= 0 ? mod : mod + count
    }
}

extension BinaryInteger {
    var isEven: Bool { isMultiple(of: 2) }
    var isOdd: Bool { !isEven }
}

extension FloatingPoint {
    var radians: Self {
        self * .pi / 180
    }

    var degrees: Self {
        self * 180 / .pi
    }
}

extension Bool {
    @inlinable
    var toggled: Bool { !self }
}

func clamp<T>(_ value: T, min minValue: T, max maxValue: T) -> T where T: Comparable {
    min(max(value, minValue), maxValue)
}
