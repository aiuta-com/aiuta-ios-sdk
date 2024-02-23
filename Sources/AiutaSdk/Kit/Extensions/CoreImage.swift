//
// Created by nGrey on 05.04.2023.
//

import CoreImage
import UIKit

extension CIImage {
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

extension UIImage {
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

extension UIImage {
    func snaphot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        defer { UIGraphicsEndImageContext() }
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
