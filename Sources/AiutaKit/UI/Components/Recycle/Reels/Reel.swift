//
//  Created by nGrey on 25.05.2023.
//

import UIKit

open class Reel<ReelData>: Content<PlainView> {
    open func update(_ data: ReelData?, at index: ItemIndex, isCurrent: Bool) {}
}
