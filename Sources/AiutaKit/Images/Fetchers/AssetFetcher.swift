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

import Photos
import Resolver
import UIKit

@_spi(Aiuta) public final class AssetFetcher: BaseFetcher {
    private var fetcher: PHImageManager { PHImageManager.default() }
    private var options: PHRequestOptions { PHRequestOptions.default }
    private var requestId: PHImageRequestID?

    public init(_ asset: PHAsset, quality: ImageQuality, breadcrumbs: Breadcrumbs) {
        super.init()
        requestId = fetcher.requestImage(for: asset,
                                         targetSize: size(for: asset, with: quality),
                                         contentMode: .aspectFit,
                                         options: options(for: quality)) { [weak self] image, info in
            if image.isNil,
               (info?[PHImageCancelledKey] as? Bool).isFalseOrNil,
               let error = info?[PHImageErrorKey] as? NSError {
                breadcrumbs.fire(error, label: "Failed to fetch image from asset")
            }
            self?.onImage.fire(image)
        }
    }

    deinit {
        guard let requestId else { return }
        fetcher.cancelImageRequest(requestId)
    }
}

private extension AssetFetcher {
    func size(for asset: PHAsset, with quality: ImageQuality) -> CGSize {
        let desizredSize: CGSize = .init(square: imageTraits.largestSize(for: quality))
        let assetSize: CGSize = .init(width: asset.pixelWidth, height: asset.pixelHeight)
        return desizredSize.fit(assetSize)
    }

    func options(for quality: ImageQuality) -> PHImageRequestOptions {
        switch quality {
            case .thumbnails: return options.betterRequestOptions
            case .hiResImage: return options.strictRequestOptions
        }
    }
}

private final class PHRequestOptions {
    static let `default` = PHRequestOptions()

    let fastRequestOptions: PHImageRequestOptions
    let betterRequestOptions: PHImageRequestOptions
    let strictRequestOptions: PHImageRequestOptions

    private init() {
        fastRequestOptions = PHImageRequestOptions()
        fastRequestOptions.isNetworkAccessAllowed = true
        fastRequestOptions.deliveryMode = .fastFormat
        fastRequestOptions.isSynchronous = false
        fastRequestOptions.version = .current
        fastRequestOptions.resizeMode = .none

        betterRequestOptions = PHImageRequestOptions()
        betterRequestOptions.isNetworkAccessAllowed = true
        betterRequestOptions.deliveryMode = .opportunistic
        betterRequestOptions.isSynchronous = false
        betterRequestOptions.version = .current
        // Any mode except exact causes empty image
        betterRequestOptions.resizeMode = .exact

        strictRequestOptions = PHImageRequestOptions()
        strictRequestOptions.isNetworkAccessAllowed = true
        strictRequestOptions.deliveryMode = .highQualityFormat
        strictRequestOptions.isSynchronous = false
        strictRequestOptions.version = .current
        strictRequestOptions.resizeMode = .none
    }
}
