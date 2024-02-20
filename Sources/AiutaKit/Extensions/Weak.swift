//
//  Created by nGrey on 13.06.2023.
//

import Foundation

public final class Weak<T: AnyObject> {
    public private(set) weak var value: T?

    public init(_ value: T) {
        self.value = value
    }

    public convenience init?(_ value: T?) {
        guard let value else { return nil }
        self.init(value)
    }
}

public final class WeakOrStrong<T: AnyObject> {
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

public final class Expiring<T: AnyObject> {
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
