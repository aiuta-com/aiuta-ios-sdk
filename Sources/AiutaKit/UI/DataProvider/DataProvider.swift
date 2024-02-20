//
//  Created by nGrey on 08.06.2023.
//

import Foundation

open class DataProvider<DataType> {
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
