//
// Created by nGrey on 27.02.2023.
//

import UIKit

protocol ImageRef {
    var assetName: String { get }
    var assetGroup: String? { get }
    var horizontallyFlipped: Bool { get }
    var renderingMode: RenderingMode? { get }
}

extension ImageRef {
    var assetName: String { String(describing: self) }
    var horizontallyFlipped: Bool { false }
    var renderingMode: RenderingMode? { nil }
}

extension ImageRef {
    func uiImage() -> UIImage? {
        var imageName = assetName
        if let assetGroup { imageName = "\(assetGroup).\(assetName)" }
        var image = UIImage(named: imageName)
        if let rm = renderingMode { image = image?.withRenderingMode(rm.imageRenderingMode) }
        if horizontallyFlipped { image = image?.withHorizontallyFlippedOrientation() }
        return image
    }
}

enum RenderingMode {
    case original, template
}

extension RenderingMode {
    var imageRenderingMode: UIImage.RenderingMode {
        switch self {
            case .original:
                return .alwaysOriginal
            case .template:
                return .alwaysTemplate
        }
    }
}
