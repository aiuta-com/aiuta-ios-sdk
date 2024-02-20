//
// Created by nGrey on 04.02.2023.
//

import Resolver
import UIKit

open class Image: Content<PlainImageView> {
    public let gotImage = Signal<Void>()

    public var image: UIImage? {
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

    public var imageUrl: String? {
        get { view.imageUrl }
        set { view.imageUrl = newValue }
    }

    public var tint: UIColor {
        get { view.tintColor }
        set { view.tintColor = newValue }
    }

    public var contentMode: UIView.ContentMode {
        get { view.contentMode }
        set { view.contentMode = newValue }
    }

    public var isAutoSize = true

    public convenience init(_ builder: (_ it: Image, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }

    public convenience init(view: PlainImageView, _ builder: (_ it: Image, _ ds: DesignSystem) -> Void) {
        self.init(view: view)
        builder(self, ds)
    }
}
