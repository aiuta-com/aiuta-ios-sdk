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

import CryptoKit
import Foundation

@propertyWrapper
@_spi(Aiuta) public final class defaults<T: Codable> {
    public let onValueChanged = Signal<T>(retainLastData: true)

    private let key: String
    private let etagKey: String
    public let defaultValue: T
    private var cachedValue: T?
    private let userDefaults: UserDefaults = .standard

    public init(key: String, defaultValue: T, ignoreApiKey: Bool = false) {
        self.key = key + (ignoreApiKey ? "" : keySuffix)
        etagKey = "\(self.key)_etag"
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
        dispatch(.mainAsync) { [self] in
            onValueChanged.fire(defaultValue)
        }
    }
}

private var keySuffix: String = ""

private func hash(_ source: String) -> String {
    if #available(iOS 13.0, *) {
        return Insecure.MD5.hash(data: source.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
    } else {
        return source
    }
}

@_spi(Aiuta) public func setDefaults(apiKey: String) {
    keySuffix = "_\(hash(apiKey))"
}
