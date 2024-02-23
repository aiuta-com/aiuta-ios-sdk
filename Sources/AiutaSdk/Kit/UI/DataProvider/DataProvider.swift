//
//  Created by nGrey on 08.06.2023.
//

import Foundation

class DataProvider<DataType> {
    let onUpdate = Signal<Void>()

    var items: [DataType] {
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

    private(set) var wasUpdated: Bool = false

    var canUpdate: Bool {
        false
    }

    var isEmpty: Bool {
        items.isEmpty && !canUpdate
    }

    init() {
        items = []
    }

    init(_ items: [DataType]) {
        self.items = items
    }

    func requestUpdate() {
        guard canUpdate, !needUpate else { return }
        needUpate = true
    }

    func implementUpdate() {}

    func remove(at index: ItemIndex) {
        items.remove(at: index.item)
    }

    func removeAll(where shouldBeRemoved: (DataType) -> Bool) {
        items.removeAll(where: shouldBeRemoved)
    }

    func removeAll() {
        wasUpdated = false
        guard !items.isEmpty else {
            return
        }
        items.removeAll()
        wasUpdated = false
    }
}
