//
//  Created by nGrey on 25.05.2023.
//

import Foundation

@propertyWrapper
final class defaults<T: Codable> {
    let onValueChanged = Signal<T>(retainLastData: true)

    private let key: String
    private let etagKey: String
    private let defaultValue: T
    private var cachedValue: T?
    private let userDefaults: UserDefaults = .standard

    init(key: String, defaultValue: T) {
        self.key = key
        etagKey = "\(key)_etag"
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
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

    var etag: String? {
        get { userDefaults.string(forKey: etagKey) }
        set {
            if let newValue { userDefaults.setValue(newValue, forKey: etagKey) }
            else { userDefaults.removeObject(forKey: etagKey) }
        }
    }

    var projectedValue: defaults<T> {
        self
    }

    func erase() {
        etag = nil
        cachedValue = nil
        userDefaults.removeObject(forKey: key)
    }
}
