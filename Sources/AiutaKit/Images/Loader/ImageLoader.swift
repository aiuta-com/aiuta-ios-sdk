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

final class ImageLoader {
    let onImage = Signal<(UIImage, ImageQuality)>(retainLastData: true)

    let source: ImageSource
    private var fetchers = [ImageQuality: ImageFetcher]()

    private init(_ source: ImageSource) {
        self.source = source
    }

    func load(_ quality: ImageQuality) {
        if quality > .thumbnails && fetchers[.thumbnails].isNil { load(.thumbnails) }

        let fetcher: ImageFetcher = fetchers[quality] ?? source.fetcher(for: quality)

        fetchers[quality] = fetcher
        fetcher.onImage.cancelSubscription(for: self)
        fetcher.onImage.subscribePast(with: self) { [unowned self] image in
            if let image { onImage.fire((image, quality)) }
        }
    }

    @available(iOS 13.0.0, *)
    @MainActor func prefetch(_ quality: ImageQuality = .thumbnails) async throws {
        _ = try await fetch(quality)
    }

    @available(iOS 13.0.0, *)
    @MainActor func fetch(_ quality: ImageQuality = .hiResImage) async throws -> UIImage {
        let fetcher: ImageFetcher = fetchers[quality] ?? source.fetcher(for: quality)
        fetchers[quality] = fetcher
        return try await fetcher.fetch()
    }
}

extension ImageLoader: Equatable {
    static func == (lhs: ImageLoader, rhs: ImageLoader) -> Bool {
        lhs.source.isSame(as: rhs.source)
    }
}

extension ImageLoader {
    private static var cache = [Expiring<ImageLoader>]()

    static func Cached(_ source: ImageSource) -> ImageLoader {
        cache.removeAll(where: { $0.expire(prolongUsed: true) })

        if let expiring = cache.first(where: { $0.value?.source.isSame(as: source) ?? false }),
           let cached = expiring.value {
            expiring.prolong()
            return cached
        }

        let loader = ImageLoader(source)
        cache.append(Expiring(loader, expireAfter: .severalSeconds))
        return loader
    }
}
