//
//  Created by nGrey on 05.07.2023.
//

import UIKit

public final class SwipeEdge: Plane {
    var width: CGFloat = 20

    public convenience init(width: CGFloat) {
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
