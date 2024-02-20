//
//  Created by nGrey on 21.04.2023.
//

import UIKit

open class Scroll: Plane {
    public let scrollView = VScroll()

    public var maxWidth: CGFloat?

    override func inspectChild(_ child: Any) -> Bool {
        if let scrollable = child as? ScrollWrapped {
            scrollView.addContent(scrollable.content)
            return true
        }
        return false
    }

    override func updateLayoutInternal() {
        scrollView.layout.make { make in
            make.size = layout.size
            if let maxWidth {
                make.width = min(maxWidth, make.width)
                make.centerX = 0
            }
        }
    }
}

protocol ScrollWrapped {
    var content: ContentBase { get }
}

@propertyWrapper public struct scrollable<ViewType>: ScrollWrapped where ViewType: ContentBase {
    var content: ContentBase {
        wrappedValue as ContentBase
    }

    public var wrappedValue: ViewType

    public init(wrappedValue: ViewType) {
        self.wrappedValue = wrappedValue
    }
}
