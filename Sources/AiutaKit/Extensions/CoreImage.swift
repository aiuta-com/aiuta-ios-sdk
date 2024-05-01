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

import CoreImage
import UIKit

@_spi(Aiuta) public extension CGImage {
    var averageColor: UIColor.HSLA? {
        CIImage(cgImage: self).averageColor
    }
}

@_spi(Aiuta) public extension CIImage {
    var averageColor: UIColor.HSLA? {
        averageUIColor?.hsla
    }

    var averageUIColor: UIColor? {
        let extentVector = CIVector(x: extent.origin.x, y: extent.origin.y, z: extent.size.width, w: extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: self, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }

    func createCGImage() -> CGImage? {
        let ciContext = CIContext(options: nil)
        return ciContext.createCGImage(self, from: extent)
    }

    func crop(to cgImage: CGImage) -> CIImage {
        cropped(to: .init(width: cgImage.width, height: cgImage.height))
    }

    func resize(to cgImage: CGImage) -> CIImage {
        resize(width: CGFloat(cgImage.width), height: CGFloat(cgImage.height))
    }

    func resize(to ciImage: CIImage) -> CIImage {
        resize(to: ciImage.extent.size)
    }

    func resize(to size: CGSize) -> CIImage {
        resize(width: size.width, height: size.height)
    }

    func resize(width: CGFloat, height: CGFloat) -> CIImage {
        let selfSize = extent.size
        let transform = CGAffineTransform(scaleX: width / selfSize.width, y: height / selfSize.height)
        return transformed(by: transform)
    }
}

@_spi(Aiuta) extension UIImage {
    func roundedCornerImage(with radius: CGFloat) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { rendererContext in
            let rect = CGRect(origin: .zero, size: size)
            let path = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: .allCorners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            path.close()

            let cgContext = rendererContext.cgContext
            cgContext.saveGState()
            path.addClip()
            draw(in: rect)
            cgContext.restoreGState()
        }
    }
}

@_spi(Aiuta) public extension UIImage {
    func snaphot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}

@_spi(Aiuta) public extension UIImage {
    var averageColor: UIColor? {
        guard let ciImage = CIImage(image: self) else { return nil }
        return ciImage.averageUIColor
    }
}
