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

import Foundation
import Kingfisher
import Resolver
import UIKit

@_spi(Aiuta) public final class ThumbFetcher: BaseFetcher {
    private let urlFetcher: UrlFetcher
    private var downsampler: Downsampler?

    public init(_ string: String, quality: ImageQuality, isRounded: Bool = false) {
        urlFetcher = UrlFetcher(string, quality: .hiResImage, isRounded: isRounded)
        super.init()
        load(quality)
    }

    public init(_ url: URL, quality: ImageQuality, isRounded: Bool = false) {
        urlFetcher = UrlFetcher(url, quality: .hiResImage, isRounded: isRounded)
        super.init()
        load(quality)
    }
}

private extension ThumbFetcher {
    func load(_ quality: ImageQuality) {
        switch quality {
            case .thumbnails: waitOriginalAndDownsample()
            case .hiResImage: forwardOriginal()
        }
    }

    private func forwardOriginal() {
        urlFetcher.onImage.subscribePast(with: self) { [unowned self] image in
            onImage.fire(image)
        }
    }

    private func waitOriginalAndDownsample() {
        urlFetcher.onImage.subscribePast(with: self) { [unowned self] original in
            guard let original else {
                onImage.fire(nil)
                return
            }
            downsampler = Downsampler(original, quality: .thumbnails)
            downsampler?.onImage.subscribePastOnce(with: self) { [unowned self] downsampledImage in
                let resultImage = downsampledImage ?? original
                onImage.fire(resultImage)
            }
        }
    }
}
