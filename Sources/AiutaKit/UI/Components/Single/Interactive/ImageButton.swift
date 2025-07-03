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

@_spi(Aiuta) open class ImageButton: Content<TouchView> {
    public var onTouchDown: Signal<Void> { view.onTouchDown }
    public var onTouchUpInside: Signal<Void> { view.onTouchUpInside }
    public var onTouchUp: Signal<Void> { view.onTouchUp }
    public var onLongTouch: Signal<Void> { view.onLongTouch }

    public var image: UIImage? {
        get { imageView.image }
        set {
            imageView.image = newValue
            imageView.tint = ds.kit.tint
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
