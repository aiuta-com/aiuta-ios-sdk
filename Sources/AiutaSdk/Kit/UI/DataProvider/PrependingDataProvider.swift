//
//  Created by nGrey on 29.06.2023.
//

import Foundation

class PrependingDataProvider<DataType>: DataProvider<DataType> {
    private let underliyngDataProvider: DataProvider<DataType>
    private let prependingItems: [DataType]
    private let prependIfEmpty: Bool

    override var canUpdate: Bool {
        underliyngDataProvider.canUpdate
    }

    init(prependingItems: [DataType], with underliyngDataProvider: DataProvider<DataType>, prependIfEmpty: Bool = false) {
        self.underliyngDataProvider = underliyngDataProvider
        self.prependingItems = prependingItems
        self.prependIfEmpty = prependIfEmpty
        super.init(prependIfEmpty || !underliyngDataProvider.items.isEmpty ? prependingItems + underliyngDataProvider.items : [])
        underliyngDataProvider.onUpdate.subscribe(with: self) { [unowned self] in
            updateItemsFromUnderliyng()
        }
    }

    override func implementUpdate() {
        underliyngDataProvider.implementUpdate()
    }

    private func updateItemsFromUnderliyng() {
        if prependIfEmpty || !underliyngDataProvider.items.isEmpty {
            items = prependingItems + underliyngDataProvider.items
        } else {
            items = []
        }
    }
}
