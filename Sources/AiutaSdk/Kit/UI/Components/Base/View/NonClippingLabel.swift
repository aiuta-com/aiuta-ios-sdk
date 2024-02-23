//
//  Created by nGrey on 10.07.2023.
//

import UIKit

final class NonClippingLabel: UILabel {
    private var gutter: CGFloat = 4

    convenience init(gutter: CGFloat) {
        self.init(frame: .zero)
        self.gutter = gutter
    }

    override func draw(_ rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: gutter, dy: 0))
    }

    override var alignmentRectInsets: UIEdgeInsets {
        return .init(top: gutter, left: gutter, bottom: 0, right: gutter)
    }

    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += gutter * 2
        size.height += gutter

        return size
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let fixedSize = CGSize(width: size.width - 2 * gutter,
                               height: size.height - gutter)
        let sizeWithoutGutter = super.sizeThatFits(fixedSize)

        return CGSize(width: sizeWithoutGutter.width + 2 * gutter,
                      height: sizeWithoutGutter.height + gutter)
    }
}
