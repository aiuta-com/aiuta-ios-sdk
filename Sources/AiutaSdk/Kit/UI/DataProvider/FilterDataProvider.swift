//
//  Created by nGrey on 29.07.2023.
//

import Foundation

class FilterDataProvider<DataType>: DataProvider<DataType> {
    private let underliyngDataProvider: DataProvider<DataType>
    var filter: (DataType) -> Bool {
        didSet { updateItemsFromUnderliyng() }
    }

    override var canUpdate: Bool {
        underliyngDataProvider.canUpdate
    }

    init(input underliyngDataProvider: DataProvider<DataType>, filter: @escaping (DataType) -> Bool) {
        self.filter = filter
        self.underliyngDataProvider = underliyngDataProvider
        super.init(underliyngDataProvider.items.filter(filter))
        underliyngDataProvider.onUpdate.subscribe(with: self) { [unowned self] in
            updateItemsFromUnderliyng()
        }
    }
    
    func updateFilter() {
        updateItemsFromUnderliyng()
    }

    override func implementUpdate() {
        underliyngDataProvider.implementUpdate()
    }

    private func updateItemsFromUnderliyng() {
        items = underliyngDataProvider.items.filter(filter)
    }
}
