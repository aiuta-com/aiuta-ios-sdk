// Copyright 2024 Aiuta USA, Inc
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit

@_spi(Aiuta) open class Image: Content<PlainImageView> {
    public let gotImage = Signal<Void>()

    public var image: UIImage? {
        get { view.image }
        set {
            guard newValue != image else { return }
            view.image = newValue
            gotImage.fire()
            if isAutoSize, let size = newValue?.size {
                view.frame = CGRect(size: size)
            }
            parent?.updateLayoutRecursive()
        }
    }

    public var tint: UIColor {
        get { view.tintColor }
        set { view.tintColor = newValue }
    }

    public var contentMode: UIView.ContentMode {
        get { view.contentMode }
        set { view.contentMode = newValue }
    }

    public var hasImage: Bool {
        image.isSome
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
