//
//  Created by nGrey on 22.06.2023.
//

import UIKit

public struct RoundedCorners: Equatable {
    public static var zero: RoundedCorners { .init() }

    public var topLeft: CGFloat
    public var topRight: CGFloat
    public var bottomLeft: CGFloat
    public var bottomRight: CGFloat

    public init(topLeft: CGFloat = 0, topRight: CGFloat = 0, bottomLeft: CGFloat = 0, bottomRight: CGFloat = 0) {
        self.topLeft = topLeft
        self.topRight = topRight
        self.bottomLeft = bottomLeft
        self.bottomRight = bottomRight
    }

    public init(left: CGFloat, right: CGFloat) {
        topLeft = left
        topRight = right
        bottomLeft = left
        bottomRight = right
    }

    public init(top: CGFloat, bottom: CGFloat) {
        topLeft = top
        topRight = top
        bottomLeft = bottom
        bottomRight = bottom
    }
}
