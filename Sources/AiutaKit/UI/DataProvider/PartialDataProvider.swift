//
//  Created by nGrey on 27.06.2023.
//

import Foundation

open class PartialDataProvider<DataType>: DataProvider<DataType> {
    private let constantItems: [DataType]
    private var currentPrefix: Int = 0
    
    public var chunkSize: Int = 10
    
    open override var canUpdate: Bool {
        currentPrefix < constantItems.count
    }
    
    override public init(_ items: [DataType]) {
        constantItems = items
        super.init([])
    }

    override public init() {
        constantItems = []
        super.init()
    }
    
    open override func implementUpdate() {
        currentPrefix = min(currentPrefix + chunkSize, constantItems.count)
        items = Array(constantItems.prefix(currentPrefix))
    }
}
