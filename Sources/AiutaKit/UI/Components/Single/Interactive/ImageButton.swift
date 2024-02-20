//
// Created by nGrey on 27.02.2023.
//

import UIKit

open class ImageButton: Content<TouchView> {
    public var onTouchDown: Signal<Void> { view.onTouchDown }
    public var onTouchUpInside: Signal<Void> { view.onTouchUpInside }
    public var onLongTouch: Signal<Void> { view.onLongTouch }

    public var image: UIImage? {
        get { imageView.image }
        set {
            imageView.image = newValue
            imageView.tint = ds.color.tint
        }
    }

    public var tint: UIColor {
        get { imageView.tint }
        set { imageView.tint = newValue }
    }

    public let imageView = Image()
    public var imageInsets = UIEdgeInsets(inset: 10)

    override func sizeToFit() {
        if layout.size.isAnyZero {
            layout.make { $0.size = imageView.layout.size + imageInsets }
        }

        imageView.layout.make { $0.center = .zero }
    }

    public convenience init(_ builder: (_ it: ImageButton, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
