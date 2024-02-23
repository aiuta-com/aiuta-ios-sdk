//
// Created by nGrey on 03.02.2023.
//

import Foundation

extension Optional {
    @inlinable var isSome: Bool { self != nil }
    @inlinable var isNil: Bool { self == nil }
}

extension Optional where Wrapped == Bool {
    @inlinable static prefix func ! (_ optional: Bool?) -> Bool? {
        optional?.toggled
    }

    @inlinable var isTrue: Bool {
        guard let self = self else { return false }
        return self
    }

    @inlinable var isTrueOrNil: Bool {
        guard let self = self else { return true }
        return self
    }

    @inlinable var isFalse: Bool {
        guard let self = self else { return false }
        return !self
    }

    @inlinable var isFalseOrNil: Bool {
        guard let self = self else { return true }
        return !self
    }
}

extension Optional where Wrapped: Collection {
    @inlinable var isNullOrEmpty: Bool {
        guard let wrapped = self else { return true }
        return wrapped.isEmpty
    }

    @inlinable var isSomeAndNotEmpty: Bool {
        guard let wrapped = self else { return false }
        return !wrapped.isEmpty
    }
}
