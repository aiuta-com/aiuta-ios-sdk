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
    /// Internal observation implementation.
    actor _ObservableActor<Value: Sendable> {
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
