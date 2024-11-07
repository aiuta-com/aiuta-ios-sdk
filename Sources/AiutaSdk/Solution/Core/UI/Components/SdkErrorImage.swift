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

@_spi(Aiuta) import AiutaKit
import UIKit

final class ErrorImage: Stroke {
    let errorIcon = Image { it, ds in
        it.image = ds.image.icon36(.imageError)
        it.tint = ds.color.primary
        it.view.isVisible = false
    }

    private var isLargeIcon = false {
        didSet { updateLayout() }
    }

    override func updateLayout() {
        errorIcon.layout.make { make in
            make.square = isLargeIcon ? 54 : 36
            make.center = .zero
        }
    }

    func link(with imageView: Image, whole: Bool = false) {
        errorIcon.view.isVisible = whole
        isLargeIcon = whole

        imageView.gotImage.subscribePast(with: self) { [unowned self] in
            (whole ? self : errorIcon).animations.visibleTo(!imageView.hasImage)
        }

        imageView.onChange.subscribePast(with: self) { [unowned self] in
            (whole ? self : errorIcon).animations.visibleTo(false)
        }

        imageView.onError.subscribePast(with: self) { [unowned self] in
            (whole ? self : errorIcon).animations.visibleTo(true)
        }
    }

    convenience init(_ builder: (_ it: ErrorImage, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
