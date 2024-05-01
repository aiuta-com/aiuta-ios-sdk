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

@_spi(Aiuta) open class BaseWatermarker {
    public let watermark: UIImage?

    public init(_ watermark: UIImage?) {
        self.watermark = watermark
    }

    open func watermark(_ image: UIImage, rect waterRect: CGRect) -> UIImage {
        guard let watermark else { return image }
        let imageRect = CGRect(size: image.size)

        UIGraphicsBeginImageContextWithOptions(imageRect.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return image }

        context.setFillColor(UIColor.black.cgColor)
        context.fill(imageRect)

        image.draw(in: imageRect, blendMode: .normal, alpha: 1)
        watermark.draw(in: waterRect, blendMode: .normal, alpha: 1)

        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return result ?? image
    }
}
