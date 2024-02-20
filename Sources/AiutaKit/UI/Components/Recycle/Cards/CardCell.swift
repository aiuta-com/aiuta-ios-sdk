//
//  Created by nGrey on 19.04.2023.
//

import UIKit

open class CardCell<CardCellData>: Content<PlainView> {
    open func update(_ data: CardCellData, at index: ItemIndex) {}
}
