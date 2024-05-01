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
import UIKit

@_spi(Aiuta) public extension UIImageView {
    private struct Property {
        static var imageUrl: Void?
    }

    var imageUrl: String? {
        get { getAssociatedProperty(&Property.imageUrl, ofType: String.self) }
        set { loadImage(newValue) }
    }

    func loadImage(_ urlString: String?, completion: AsyncCallback? = nil) {
        setAssociatedProperty(&Property.imageUrl, newValue: urlString)
        kf.cancelDownloadTask()
        guard let urlString = urlString else { image = nil; return }
        guard let url = URL(string: urlString) else { return }
        kf.setImage(with: url, options: [
            .downloadPriority(URLSessionTask.highPriority),
            .retryStrategy(DelayRetryStrategy(maxRetryCount: 3)),
            .processor(DownsamplingImageProcessor(size: .init(square: 1500))),
            .memoryCacheExpiration(.seconds(360)),
            .diskCacheExpiration(.days(7)),
            .diskCacheAccessExtendingExpiration(.cacheTime),
            .transition(.fade(0.2)),
            .backgroundDecode,
        ]) { _ in
            completion?()
        }
    }
}
