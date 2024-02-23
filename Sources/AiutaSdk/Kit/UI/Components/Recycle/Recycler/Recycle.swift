//
//  Created by nGrey on 08.06.2023.
//

import UIKit

class Recycle<RecycleDataType>: PlainButton {
    internal let didInvalidate = Signal<RecycleDataType>()

    internal var isVisited = false
    internal var isUsed = false {
        didSet {
            view.isVisible = isUsed
            view.isUserInteractionEnabled = isUsed
        }
    }

    var data: RecycleDataType?
    var index: ItemIndex = .init(-1, of: 0)

    func update(_ data: RecycleDataType?, at index: ItemIndex) {}

    func invalidate() {
        guard let data else { return }
        didInvalidate.fire(data)
    }
}
