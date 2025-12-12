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

extension Aiuta {
    /// A generic wrapper for a value that can be observed for changes. This is
    /// needed fot Aiuta SDK to monitor a value and react to its changes.
    public final class Observable<Value: Sendable>: @unchecked Sendable {
        private let actor: ObservableActor<Value>

        /// The value being observed. When this value is updated, all observers
        /// are automatically notified through the `didChange` signal.
        public var value: Value {
            didSet {
                let newValue = value
                Task { [actor] in
                    await actor.notify(newValue)
                }
            }
        }

        /// Initializes an observable value with a given initial value.
        ///
        /// - Parameter value: The initial value to be observed.
        public init(_ value: Value) {
            self.value = value
            actor = ObservableActor(value)
        }

        @_spi(Aiuta)
        @discardableResult
        public func addListener(
            fireImmediately: Bool = true,
            _ listener: @escaping @Sendable (Value) -> Void
        ) async -> UUID {
            await actor.addListener(fireImmediately: fireImmediately, listener)
        }

        @_spi(Aiuta)
        public func removeListener(_ id: UUID) async {
            await actor.removeListener(id)
        }
    }
}

//// MARK: - Codable conformance when T: Codable
extension Aiuta.Observable: Codable where Value: Codable {
    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(Value.self)
        self.init(value)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

extension Aiuta {
    /// Internal observation implementation.
    @_spi(Aiuta) public actor ObservableActor<Value: Sendable> {
        public typealias Listener = @Sendable (Value) -> Void

        private var current: Value
        private var listeners: [UUID: Listener] = [:]

        public init(_ value: Value) {
            current = value
        }

        @discardableResult
        public func addListener(
            fireImmediately: Bool = false,
            _ listener: @escaping Listener
        ) -> UUID {
            let id = UUID()

            listeners[id] = { value in
                Task { @MainActor in
                    listener(value)
                }
            }

            if fireImmediately {
                listeners[id]?(current)
            }

            return id
        }

        public func removeListener(_ id: UUID) {
            listeners.removeValue(forKey: id)
        }

        public func notify(_ value: Value) {
            current = value
            let currentListeners = listeners.values
            for listener in currentListeners {
                listener(value)
            }
        }
    }
}
