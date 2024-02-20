//
//  Created by nGrey on 10.07.2023.
//

import UIKit

public final class NonClippingLabel: UILabel {
    private var gutter: CGFloat = 4

    public convenience init(gutter: CGFloat) {
        self.init(frame: .zero)
        self.gutter = gutter
    }

    override public func draw(_ rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: gutter, dy: 0))
    }

    override public var alignmentRectInsets: UIEdgeInsets {
        return .init(top: gutter, left: gutter, bottom: 0, right: gutter)
    }

    override public var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += gutter * 2
        size.height += gutter

        return size
    }

    override public func sizeThatFits(_ size: CGSize) -> CGSize {
        let fixedSize = CGSize(width: size.width - 2 * gutter,
                               height: size.height - gutter)
        let sizeWithoutGutter = super.sizeThatFits(fixedSize)

        return CGSize(width: sizeWithoutGutter.width + 2 * gutter,
                      height: sizeWithoutGutter.height + gutter)
    }
}
