//
//  Created by nGrey on 29.07.2023.
//

import Foundation

open class FilterDataProvider<DataType>: DataProvider<DataType> {
    private let underliyngDataProvider: DataProvider<DataType>
    public var filter: (DataType) -> Bool {
        didSet { updateItemsFromUnderliyng() }
    }

    override open var canUpdate: Bool {
        underliyngDataProvider.canUpdate
    }

    public init(input underliyngDataProvider: DataProvider<DataType>, filter: @escaping (DataType) -> Bool) {
        self.filter = filter
        self.underliyngDataProvider = underliyngDataProvider
        super.init(underliyngDataProvider.items.filter(filter))
        underliyngDataProvider.onUpdate.subscribe(with: self) { [unowned self] in
            updateItemsFromUnderliyng()
        }
    }
    
    public func updateFilter() {
        updateItemsFromUnderliyng()
    }

    override open func implementUpdate() {
        underliyngDataProvider.implementUpdate()
    }

    private func updateItemsFromUnderliyng() {
        items = underliyngDataProvider.items.filter(filter)
    }
}
