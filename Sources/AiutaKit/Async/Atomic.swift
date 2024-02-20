//
// Created by nGrey on 28.03.2023.
//

import Foundation

@propertyWrapper
public struct atomic<Value> {
    private let lock = NSLock()
    private var value: Value

    public init(wrappedValue: Value) {
        value = wrappedValue
    }

    public var wrappedValue: Value {
        get {
            lock.lock()
            defer { lock.unlock() }
            return value
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            value = newValue
        }
    }
}
