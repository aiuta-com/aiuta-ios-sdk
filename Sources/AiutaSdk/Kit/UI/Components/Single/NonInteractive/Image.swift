//
// Created by nGrey on 04.02.2023.
//

import Resolver
import UIKit

class Image: Content<PlainImageView> {
    let gotImage = Signal<Void>()

    var image: UIImage? {
        get { view.image }
        set {
            guard newValue != image else { return }
            view.image = newValue
            gotImage.fire()
            guard isAutoSize, let size = newValue?.size else {
                parent?.updateLayoutRecursive()
                return
            }
            view.frame = CGRect(size: size)
            parent?.updateLayoutRecursive()
        }
    }

    var imageUrl: String? {
        get { view.imageUrl }
        set { view.imageUrl = newValue }
    }

    var tint: UIColor {
        get { view.tintColor }
        set { view.tintColor = newValue }
    }

    var contentMode: UIView.ContentMode {
        get { view.contentMode }
        set { view.contentMode = newValue }
    }

    var isAutoSize = true

    convenience init(_ builder: (_ it: Image, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }

    convenience init(view: PlainImageView, _ builder: (_ it: Image, _ ds: DesignSystem) -> Void) {
        self.init(view: view)
        builder(self, ds)
    }
}
