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

@_spi(Aiuta) public final class ImageLoader {
    let onImage = Signal<(UIImage, ImageQuality)>(retainLastData: true)

    let source: ImageSource
    private var fetchers = [ImageQuality: ImageFetcher]()

    private init(_ source: ImageSource) {
        self.source = source
    }

    func load(_ quality: ImageQuality, breadcrumbs: Breadcrumbs) {
        if quality > .thumbnails && fetchers[.thumbnails].isNil { load(.thumbnails, breadcrumbs: breadcrumbs) }

        let fetcher: ImageFetcher = fetchers[quality] ?? source.fetcher(for: quality, breadcrumbs: breadcrumbs)

        fetchers[quality] = fetcher
        fetcher.onImage.cancelSubscription(for: self)
        fetcher.onImage.subscribePast(with: self) { [unowned self] image in
            if let image { onImage.fire((image, quality)) }
        }
    }

    @available(iOS 13.0.0, *)
    @MainActor func prefetch(_ quality: ImageQuality = .thumbnails, breadcrumbs: Breadcrumbs) async throws {
        _ = try await fetch(quality, breadcrumbs: breadcrumbs)
    }

    @available(iOS 13.0.0, *)
    @MainActor func fetch(_ quality: ImageQuality = .hiResImage, breadcrumbs: Breadcrumbs) async throws -> UIImage {
        let fetcher: ImageFetcher = fetchers[quality] ?? source.fetcher(for: quality, breadcrumbs: breadcrumbs)
        fetchers[quality] = fetcher
        return try await fetcher.fetch()
    }
}

extension ImageLoader: Equatable {
    public static func == (lhs: ImageLoader, rhs: ImageLoader) -> Bool {
        lhs.source.isSame(as: rhs.source)
    }
}

extension ImageLoader {
    static func Cached(_ source: ImageSource, expireAfter: AsyncDelayTime) -> ImageLoader {
        if let expiring = cache.first(where: { $0.value?.source.isSame(as: source) ?? false }),
           let cached = expiring.value {
            expiring.prolong(expireAfter)
            return cached
        }

        let loader = ImageLoader(source)
        cache.append(Expiring(loader, expireAfter))
        return loader
    }

    private static var cache = {
        startMemoryPressureMonitor()
        interval(.oneSecond, execute: dropExpiredCache)
        return [Expiring<ImageLoader>]()
    }()

    private static func startMemoryPressureMonitor() {
        let memoryPressureMonitor = MemoryPressureMonitor.shared
        memoryPressureMonitor.onAnyMemoryWarning.subscribe(
            with: memoryPressureMonitor,
            callback: dropUnusedCache
        )
    }

    private static func dropExpiredCache() {
        cache.removeAll(where: { $0.expire(prolongUsed: true) })
    }

    private static func dropUnusedCache() {
        let was = cache.count
        cache.removeAll(where: { $0.drop(prolongUsed: true) })
        trace("Drop \(was - cache.count) of \(was) image loaders")
    }
}
