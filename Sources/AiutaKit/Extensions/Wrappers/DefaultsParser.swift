//
//  Created by nGrey on 25.05.2023.
//

import Foundation

@propertyWrapper
public final class defaults<T: Codable> {
    public let onValueChanged = Signal<T>(retainLastData: true)

    private let key: String
    private let etagKey: String
    private let defaultValue: T
    private var cachedValue: T?
    private let userDefaults: UserDefaults = .standard

    public init(key: String, defaultValue: T) {
        self.key = key
        etagKey = "\(key)_etag"
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            if let cachedValue { return cachedValue }

            guard let data = userDefaults.object(forKey: key) as? Data else {
                cachedValue = defaultValue
                return defaultValue
            }

            let value = try? JSONDecoder().decode(T.self, from: data)
            cachedValue = value ?? defaultValue
            return value ?? defaultValue
        }
        set {
            cachedValue = newValue
            let data = try? JSONEncoder().encode(newValue)
            userDefaults.set(data, forKey: key)
            dispatch(.mainAsync) { [self] in
                onValueChanged.fire(newValue)
            }
        }
    }

    public var etag: String? {
        get { userDefaults.string(forKey: etagKey) }
        set {
            if let newValue { userDefaults.setValue(newValue, forKey: etagKey) }
            else { userDefaults.removeObject(forKey: etagKey) }
        }
    }

    public var projectedValue: defaults<T> {
        self
    }

    public func erase() {
        etag = nil
        cachedValue = nil
        userDefaults.removeObject(forKey: key)
    }
}
