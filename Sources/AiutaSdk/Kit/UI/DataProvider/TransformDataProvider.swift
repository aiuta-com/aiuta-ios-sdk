//
//  Created by nGrey on 29.06.2023.
//

import Foundation

class TransformDataProvider<InDataType, OutDataType>: DataProvider<OutDataType> {
    private let underliyngDataProvider: DataProvider<InDataType>
    private let transform: (InDataType) -> OutDataType

    override var canUpdate: Bool {
        underliyngDataProvider.canUpdate
    }

    init(input underliyngDataProvider: DataProvider<InDataType>, transform: @escaping (InDataType) -> OutDataType) {
        self.transform = transform
        self.underliyngDataProvider = underliyngDataProvider
        super.init(underliyngDataProvider.items.map(transform))
        underliyngDataProvider.onUpdate.subscribe(with: self) { [unowned self] in
            updateItemsFromUnderliyng()
        }
    }

    override func implementUpdate() {
        underliyngDataProvider.implementUpdate()
    }
    
    private func updateItemsFromUnderliyng() {
        items = underliyngDataProvider.items.map(transform)
    }
}
