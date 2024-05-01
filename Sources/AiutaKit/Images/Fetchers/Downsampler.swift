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

import Kingfisher
import Resolver
import UIKit

@_spi(Aiuta) public final class Downsampler: BaseFetcher {
    private let imageCache: ImageCache = KingfisherManager.shared.cache

    public init(_ image: UIImage, quality: ImageQuality) {
        super.init()
        loadFromCache(image, quality: quality)
    }

    public init(_ data: Data, quality: ImageQuality) {
        super.init()
        dispatch(quality == .thumbnails ? .user : .medium) { [self] in
            let processor = processor(for: quality)
            let downsample = processor.process(item: .data(data), options: .init(nil))
            dispatch(.main) { [self] in
                onImage.fire(downsample)
            }
        }
    }

    func processor(for quality: ImageQuality) -> DownsamplingImageProcessor {
        DownsamplingImageProcessor(size: .init(square: imageTraits.largestSize(for: quality)))
    }
}

private extension Downsampler {
    func loadFromCache(_ image: UIImage, quality: ImageQuality) {
        imageCache.retrieveImage(forKey: image.cacheKey(for: quality)) { [weak self] result in
            switch result {
                case let .success(cache):
                    if let image = cache.image { self?.onImage.fire(image) }
                    else { self?.downsample(image, quality: quality) }
                case .failure:
                    self?.downsample(image, quality: quality)
            }
        }
    }

    func downsample(_ image: UIImage, quality: ImageQuality) {
        dispatch(quality == .thumbnails ? .user : .medium) { [self] in
            let processor = processor(for: quality)
            let downsample = processor.process(item: .image(image), options: .init(nil))
            dispatch(.main) { [self] in
                imageCache.store(downsample ?? image, forKey: image.cacheKey(for: quality), toDisk: false)
                onImage.fire(downsample ?? image)
            }
        }
    }
}

private extension UIImage {
    func cacheKey(for quality: ImageQuality) -> String {
        switch quality {
            case .hiResImage: return "\(uuid).jpg"
            case .thumbnails: return "\(uuid)-thumb.jpg"
        }
    }
}
