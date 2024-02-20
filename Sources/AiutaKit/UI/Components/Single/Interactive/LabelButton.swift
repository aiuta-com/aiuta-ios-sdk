//
// Created by nGrey on 27.02.2023.
//

import UIKit

open class LabelButton: Content<TouchView> {
    public var onTouchDown: Signal<Void> { view.onTouchDown }
    public var onTouchUpInside: Signal<Void> { view.onTouchUpInside }
    public var onLongTouch: Signal<Void> { view.onLongTouch }

    public let label = Label()
    public var labelInsets = UIEdgeInsets(horizontal: 16, vertical: 9)

    public var text: String? {
        get { label.text }
        set { label.text = newValue }
    }

    public var style: StyleRef? {
        didSet {
            font = style?.font
            label.color = style?.foregroundColor
            view.backgroundColor = style?.backgroundColor
            view.borderColor = style?.foregroundColor
            view.borderWidth = style?.borderWidth ?? 0
            view.cornerRadius = style?.cornerRadius ?? 0
        }
    }

    public var font: FontRef? {
        get { label.font }
        set { label.font = newValue }
    }

    public var color: UIColor? {
        get { view.backgroundColor }
        set { view.backgroundColor = newValue }
    }

    override func sizeToFit() {
        label.appearance.make { make in
            make.sizeToFit()
        }

        layout.make { make in
            make.size = label.layout.size + labelInsets
            if let designedHeight = style?.designedHeight {
                make.height = designedHeight
            }
        }
    }

    override open func updateLayout() {
        label.layout.make { make in
            make.centerX = 0
            make.centerY = -1
        }
    }

    public convenience init(_ builder: (_ it: LabelButton, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
