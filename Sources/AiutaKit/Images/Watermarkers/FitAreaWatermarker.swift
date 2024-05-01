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

@_spi(Aiuta) open class FitAreaWatermarker: BaseWatermarker, Watermarker {
    public enum Alignment {
        case min, mid, max
    }

    private let area: CGRect
    private let xAlign: Alignment
    private let yAlign: Alignment

    public init(_ watermark: UIImage?, area: CGRect, xAlign: Alignment = .mid, yAlign: Alignment = .mid) {
        self.area = area
        self.xAlign = xAlign
        self.yAlign = yAlign
        super.init(watermark)
    }

    public func watermark(_ image: UIImage) -> UIImage {
        guard let watermark else { return image }

        let areaRect = area * image.size
        let waterSize = watermark.size * watermark.scale
        var drawSize = areaRect.size.fit(waterSize)
        if drawSize.width > waterSize.height ||
            drawSize.height > waterSize.height {
            drawSize = waterSize
        }

        let waterRect = CGRect(x: xAlign.align(min: areaRect.minX, max: areaRect.maxX, side: drawSize.width),
                               y: yAlign.align(min: areaRect.minY, max: areaRect.maxY, side: drawSize.height),
                               size: drawSize)

        return super.watermark(image, rect: waterRect)
    }
}

private extension FitAreaWatermarker.Alignment {
    func align(min: CGFloat, max: CGFloat, side: CGFloat) -> CGFloat {
        switch self {
            case .min: return min
            case .mid: return (min + max - side) / 2
            case .max: return max - side
        }
    }
}
