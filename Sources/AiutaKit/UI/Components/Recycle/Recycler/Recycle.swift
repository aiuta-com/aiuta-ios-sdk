//
//  Created by nGrey on 08.06.2023.
//

import UIKit

open class Recycle<RecycleDataType>: PlainButton {
    internal let didInvalidate = Signal<RecycleDataType>()

    internal var isVisited = false
    internal var isUsed = false {
        didSet {
            view.isVisible = isUsed
            view.isUserInteractionEnabled = isUsed
        }
    }

    public internal(set) var data: RecycleDataType?
    public internal(set) var index: ItemIndex = .init(-1, of: 0)

    open func update(_ data: RecycleDataType?, at index: ItemIndex) {}

    public func invalidate() {
        guard let data else { return }
        didInvalidate.fire(data)
    }
}
