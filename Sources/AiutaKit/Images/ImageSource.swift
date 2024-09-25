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

@_spi(Aiuta) public protocol ImageSource: TransitionRef {
    var knownRemoteId: String? { get }
    var backgroundColor: UIColor? { get }

    func fetcher(for quality: ImageQuality, breadcrumbs: Breadcrumbs) -> ImageFetcher

    func isSame(as other: ImageSource) -> Bool
}

@_spi(Aiuta) public extension ImageSource {
    var backgroundColor: UIColor? { nil }
}

@_spi(Aiuta) public extension ImageSource where Self: Equatable {
    func isSame(as other: ImageSource) -> Bool {
        guard let otherSource = other as? Self else { return false }
        return self == otherSource
    }
}

@_spi(Aiuta) public extension ImageSource {
    @MainActor func fetch(_ quality: ImageQuality = .hiResImage, breadcrumbs: Breadcrumbs) async throws -> UIImage {
        try await ImageLoader.Cached(self, expireAfter: .severalSeconds).fetch(quality, breadcrumbs: breadcrumbs)
    }

    @MainActor func prefetch(_ quality: ImageQuality = .hiResImage, breadcrumbs: Breadcrumbs) async throws -> ImageLoader {
        let loader = ImageLoader.Cached(self, expireAfter: .severalSeconds)
        _ = try await loader.fetch(quality, breadcrumbs: breadcrumbs)
        return loader
    }

    func prefetch(_ quality: ImageQuality = .hiResImage, breadcrumbs: Breadcrumbs) {
        let loader = ImageLoader.Cached(self, expireAfter: .severalSeconds)
        Task { _ = try? await loader.fetch(quality, breadcrumbs: breadcrumbs) }
    }
}
