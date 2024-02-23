//
//  Created by nGrey on 27.06.2023.
//

import Foundation

class PartialDataProvider<DataType>: DataProvider<DataType> {
    private let constantItems: [DataType]
    private var currentPrefix: Int = 0
    
    var chunkSize: Int = 10
    
    override var canUpdate: Bool {
        currentPrefix < constantItems.count
    }
    
    override init(_ items: [DataType]) {
        constantItems = items
        super.init([])
    }

    override init() {
        constantItems = []
        super.init()
    }
    
    override func implementUpdate() {
        currentPrefix = min(currentPrefix + chunkSize, constantItems.count)
        items = Array(constantItems.prefix(currentPrefix))
    }
}
