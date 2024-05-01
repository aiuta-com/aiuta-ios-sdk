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

import Foundation

@_spi(Aiuta) public extension Int {
    func roll(_ count: Int) -> Int {
        if count <= 0 { return 0 }
        let mod = self % count
        return mod >= 0 ? mod : mod + count
    }
}

@_spi(Aiuta) public extension BinaryInteger {
    var isEven: Bool { isMultiple(of: 2) }
    var isOdd: Bool { !isEven }
}

@_spi(Aiuta) public extension FloatingPoint {
    var radians: Self {
        self * .pi / 180
    }

    var degrees: Self {
        self * 180 / .pi
    }
}

@_spi(Aiuta) public extension Bool {
    @inlinable
    var toggled: Bool { !self }
}

@_spi(Aiuta) public func clamp<T>(_ value: T, min minValue: T, max maxValue: T) -> T where T: Comparable {
    min(max(value, minValue), maxValue)
}
