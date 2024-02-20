//
//  Created by nGrey on 29.06.2023.
//

import Foundation

open class TransformDataProvider<InDataType, OutDataType>: DataProvider<OutDataType> {
    private let underliyngDataProvider: DataProvider<InDataType>
    private let transform: (InDataType) -> OutDataType

    override open var canUpdate: Bool {
        underliyngDataProvider.canUpdate
    }

    public init(input underliyngDataProvider: DataProvider<InDataType>, transform: @escaping (InDataType) -> OutDataType) {
        self.transform = transform
        self.underliyngDataProvider = underliyngDataProvider
        super.init(underliyngDataProvider.items.map(transform))
        underliyngDataProvider.onUpdate.subscribe(with: self) { [unowned self] in
            updateItemsFromUnderliyng()
        }
    }

    override open func implementUpdate() {
        underliyngDataProvider.implementUpdate()
    }
    
    private func updateItemsFromUnderliyng() {
        items = underliyngDataProvider.items.map(transform)
    }
}
