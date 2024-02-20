//
//  Created by nGrey on 20.04.2023.
//

import Foundation

public final class PageIndicator: Content<PageIndicatorView> {
    public var drawer: AdvancedPageControlDraw {
        get { view.drawer }
        set { view.drawer = newValue }
    }

    public var count: Int {
        get { view.numberOfPages }
        set {
            guard newValue != count else { return }
            view.numberOfPages = newValue
            parent?.updateLayoutRecursive()
        }
    }

    public var index: Int = 0 {
        didSet { view.setPage(index) }
    }

    public var offset: CGFloat = 0 {
        didSet { view.setPageOffset(offset) }
    }

    public var contentSize: CGSize {
        CGSize(width: (drawer.size + 6) * CGFloat(count) + 6, height: drawer.size)
    }

    public convenience init(_ builder: (_ it: PageIndicator, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
