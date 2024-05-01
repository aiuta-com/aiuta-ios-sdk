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

@_spi(Aiuta) public protocol ImageRef {
    var assetName: String { get }
    var assetGroup: String? { get }
    var horizontallyFlipped: Bool { get }
    var renderingMode: RenderingMode? { get }
}

@_spi(Aiuta) public extension ImageRef {
    var assetName: String { String(describing: self) }
    var horizontallyFlipped: Bool { false }
    var renderingMode: RenderingMode? { nil }
}

@_spi(Aiuta) public extension ImageRef {
    func uiImage() -> UIImage? {
        var imageName = assetName
        if let assetGroup { imageName = "\(assetGroup).\(assetName)" }
        var image = UIImage(named: imageName)
        if let rm = renderingMode { image = image?.withRenderingMode(rm.imageRenderingMode) }
        if horizontallyFlipped { image = image?.withHorizontallyFlippedOrientation() }
        return image
    }
}

@_spi(Aiuta) public enum RenderingMode {
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
