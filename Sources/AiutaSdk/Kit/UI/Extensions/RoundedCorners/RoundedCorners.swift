//
//  Created by nGrey on 22.06.2023.
//

import UIKit

struct RoundedCorners: Equatable {
    static var zero: RoundedCorners { .init() }

    var topLeft: CGFloat
    var topRight: CGFloat
    var bottomLeft: CGFloat
    var bottomRight: CGFloat

    init(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }

    init(left: CGFloat, right: CGFloat) {
        topLeft = left
        topRight = right
        bottomLeft = left
        bottomRight = right
    }

    init(top: CGFloat, bottom: CGFloat) {
        topLeft = top
        topRight = top
        bottomLeft = bottom
        bottomRight = bottom
    }
}
