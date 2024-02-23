//
// Created by nGrey on 27.02.2023.
//

import UIKit

class ImageButton: Content<TouchView> {
    var onTouchDown: Signal<Void> { view.onTouchDown }
    var onTouchUpInside: Signal<Void> { view.onTouchUpInside }
    var onLongTouch: Signal<Void> { view.onLongTouch }

    var image: UIImage? {
        get { imageView.image }
        set {
            imageView.image = newValue
            imageView.tint = ds.color.tint
        }
    }

    var tint: UIColor {
        get { imageView.tint }
        set { imageView.tint = newValue }
    }

    let imageView = Image()
    var imageInsets = UIEdgeInsets(inset: 10)

    override func sizeToFit() {
        if layout.size.isAnyZero {
            layout.make { $0.size = imageView.layout.size + imageInsets }
        }

        imageView.layout.make { $0.center = .zero }
    }

    convenience init(_ builder: (_ it: ImageButton, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
