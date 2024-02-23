//
//  Created by nGrey on 05.07.2023.
//

import UIKit

final class SwipeEdge: Plane {
    var width: CGFloat = 20

    convenience init(width: CGFloat) {
        self.init()
        self.width = width
    }

    override func updateLayoutInternal() {
        layout.make { make in
            make.width = width
            make.height = layout.boundary.height
        }
    }
}
