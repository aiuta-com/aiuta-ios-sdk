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

@_spi(Aiuta) public extension Optional {
    @inlinable var isSome: Bool { self != nil }
    @inlinable var isNil: Bool { self == nil }
}

@_spi(Aiuta) public extension Optional where Wrapped == Bool {
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

@_spi(Aiuta) public extension Optional where Wrapped: Collection {
    @inlinable var isNullOrEmpty: Bool {
        guard let wrapped = self else { return true }
        return wrapped.isEmpty
    }

    @inlinable var isSomeAndNotEmpty: Bool {
        guard let wrapped = self else { return false }
        return !wrapped.isEmpty
    }
}
