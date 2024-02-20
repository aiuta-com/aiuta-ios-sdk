//
// Created by nGrey on 03.02.2023.
//

import Foundation

public extension Sequence {
    @inlinable
    func nonnull<T>() -> [T] where Element == T? { compactMap { $0 } }
}

public extension Sequence where Element == Character {
    @inlinable
    func toString() -> String {
        String(self)
    }
}

public extension Sequence {
    @inlinable
    var indexed: EnumeratedSequence<Self> { enumerated() }
}
