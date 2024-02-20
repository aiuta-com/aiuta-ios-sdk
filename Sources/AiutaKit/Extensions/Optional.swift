//
// Created by nGrey on 03.02.2023.
//

import Foundation

extension Optional {
    @inlinable public var isSome: Bool { self != nil }
    @inlinable public var isNil: Bool { self == nil }
}

extension Optional where Wrapped == Bool {
    @inlinable public static prefix func ! (_ optional: Bool?) -> Bool? {
        optional?.toggled
    }

    @inlinable public var isTrue: Bool {
        guard let self = self else { return false }
        return self
    }

    @inlinable public var isTrueOrNil: Bool {
        guard let self = self else { return true }
        return self
    }

    @inlinable public var isFalse: Bool {
        guard let self = self else { return false }
        return !self
    }

    @inlinable public var isFalseOrNil: Bool {
        guard let self = self else { return true }
        return !self
    }
}

extension Optional where Wrapped: Collection {
    @inlinable public var isNullOrEmpty: Bool {
        guard let wrapped = self else { return true }
        return wrapped.isEmpty
    }

    @inlinable public var isSomeAndNotEmpty: Bool {
        guard let wrapped = self else { return false }
        return !wrapped.isEmpty
    }
}
