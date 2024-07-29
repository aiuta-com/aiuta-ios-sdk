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

    public init(_ image: UIImage, quality: ImageQuality, breadcrumbs: Breadcrumbs) {
        super.init()
        loadFromCache(image, quality: quality)
    }

    public init(_ data: Data, quality: ImageQuality, breadcrumbs: Breadcrumbs) {
        super.init()
        dispatch(quality == .thumbnails ? .user : .medium) { [self] in
            let downsampledImage = downsample(data, quality)
            dispatch(.mainAsync) { [self] in
                if let downsampledImage {
                    onImage.fire(UIImage(cgImage: downsampledImage))
                } else if let image = UIImage(data: data) {
                    onImage.fire(image)
                } else {
                    onImage.fire(nil)
                }
            }
        }
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
            let downsampledImage = downsample(image.pngData(), quality)
            dispatch(.mainAsync) { [self] in
                let result: UIImage
                if let downsampledImage { result = UIImage(cgImage: downsampledImage) } else { result = image }
                imageCache.store(result, forKey: image.cacheKey(for: quality), toDisk: false)
                onImage.fire(result)
            }
        }
    }

    func downsample(_ data: Data?, _ quality: ImageQuality) -> CGImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let data, let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else {
            return nil
        }

        let size = imageTraits.largestSize(for: quality)
        let downsampledOptions = [kCGImageSourceCreateThumbnailFromImageAlways: true,
                                  kCGImageSourceShouldCacheImmediately: true,
                                  kCGImageSourceCreateThumbnailWithTransform: true,
                                  kCGImageSourceThumbnailMaxPixelSize: size] as CFDictionary

        return CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampledOptions)
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
