//
// Created by nGrey on 01.03.2023.
//

import UIKit

class Stack: Content<PlainView> {
    convenience init(_ builder: (_ it: Stack, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }

    override func updateLayoutInternal() {
        let itemWidth = layout.width / CGFloat(subcontents.count)
        subcontents.indexed.forEach { i, sub in
            sub.layout.make { make in
                make.width = itemWidth
                make.height = layout.height
                make.left = CGFloat(i) * itemWidth
            }
        }
    }
}

extension UIStackView {
    func arrange(_ content: ContentBase) {
        addArrangedSubview(content.container)
    }

    func addSpace(_ value: CGFloat, after content: ContentBase) {
        setCustomSpacing(value, after: content.container)
    }
}
