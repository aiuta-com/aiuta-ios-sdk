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

@_spi(Aiuta) open class DataProvider<DataType> {
    public let onUpdate = Signal<Void>()

    public var items: [DataType] {
        didSet {
            onUpdate.fireInMainThread()
            wasUpdated = true
            needUpate = false
        }
    }

    private var needUpate = false {
        didSet {
            guard oldValue != needUpate else { return }
            if needUpate { implementUpdate() }
        }
    }

    public private(set) var wasUpdated: Bool = false

    open var canUpdate: Bool {
        false
    }

    open var isEmpty: Bool {
        items.isEmpty && !canUpdate
    }

    public init() {
        items = []
    }

    public init(_ items: [DataType]) {
        self.items = items
    }
    
    public convenience init?(_ items: [DataType]?) {
        guard let items else { return nil }
        self.init(items)
    }

    public func requestUpdate() {
        guard canUpdate, !needUpate else { return }
        needUpate = true
    }

    open func implementUpdate() {}

    public func remove(at index: ItemIndex) {
        items.remove(at: index.item)
    }

    public func removeAll(where shouldBeRemoved: (DataType) -> Bool) {
        items.removeAll(where: shouldBeRemoved)
    }

    open func removeAll() {
        wasUpdated = false
        guard !items.isEmpty else {
            return
        }
        items.removeAll()
        wasUpdated = false
    }
}
