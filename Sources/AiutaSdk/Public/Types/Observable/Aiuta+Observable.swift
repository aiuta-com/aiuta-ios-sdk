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

@_spi(Aiuta) import AiutaKit

extension Aiuta {
    /// A generic wrapper for a value that can be observed for changes. This is
    /// needed fot Aiuta SDK to monitor a value and react to its changes.
    public struct Observable<T> {
        /// A signal that triggers notifications when the observed value changes.
        /// Observers can subscribe to this signal to be informed of updates.
        let didChange = Signal<Void>()

        /// The value being observed. When this value is updated, all observers
        /// are automatically notified through the `didChange` signal.
        public var value: T {
            didSet { notifyChanges() }
        }

        /// Initializes an observable value with a given initial value.
        ///
        /// - Parameter value: The initial value to be observed.
        public init(_ value: T) {
            self.value = value
        }

        /// Notifies all observers that the value has changed. This method is
        /// called automatically when the `value` property is updated, so you
        /// typically do not need to call it manually.
        public func notifyChanges() {
            didChange.fire()
        }
    }
}

// MARK: - Codable conformance when T: Codable

extension Aiuta.Observable: Codable where T: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(T.self)
        self.init(value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

// MARK: - Sendable conformance when T: Sendable
extension Aiuta.Observable: Sendable where T: Sendable {}
