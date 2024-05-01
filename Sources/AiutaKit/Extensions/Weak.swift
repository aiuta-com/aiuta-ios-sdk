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

@_spi(Aiuta) public final class Weak<T: AnyObject> {
    public private(set) weak var value: T?

    public init(_ value: T) {
        self.value = value
    }

    public convenience init?(_ value: T?) {
        guard let value else { return nil }
        self.init(value)
    }
}

@_spi(Aiuta) public final class WeakOrStrong<T: AnyObject> {
    private weak var weakValue: T?
    private var strongValue: T?

    public var value: T? {
        strongValue ?? weakValue
    }

    public init(_ value: T, isWeak: Bool) {
        if isWeak {
            weakValue = value
        } else {
            strongValue = value
        }
    }
}

@_spi(Aiuta) public final class Expiring<T: AnyObject> {
    private weak var weakValue: T?
    private var strongValue: T?

    private var expireAt: TimeInterval
    private let expireAfter: AsyncDelayTime

    public var value: T? {
        strongValue ?? weakValue
    }

    public init(_ value: T, expireAfter: AsyncDelayTime) {
        weakValue = value
        strongValue = value
        self.expireAfter = expireAfter
        expireAt = Date().timeIntervalSince1970 + expireAfter.seconds
    }

    public func prolong() {
        expireAt = Date().timeIntervalSince1970 + expireAfter.seconds
    }

    public func expire(prolongUsed: Bool) -> Bool {
        if expireAt <= Date().timeIntervalSince1970 {
            strongValue = nil
        }

        if let weakValue {
            strongValue = weakValue
            if prolongUsed {
                prolong()
            }
            return false
        }

        return true
    }
}
