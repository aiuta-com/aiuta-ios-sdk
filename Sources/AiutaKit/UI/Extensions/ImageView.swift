//
// Created by nGrey on 02.02.2023.
//

import Kingfisher
import UIKit

public extension UIImageView {
    private struct Property {
        static var imageUrl: Void?
        static var isHiRes: Bool = false
    }

    var imageUrl: String? {
        get { getAssociatedProperty(&Property.imageUrl, ofType: String.self) }
        set { loadImage(newValue) }
    }

    var isHiRes: Bool {
        get { getAssociatedProperty(&Property.isHiRes, defaultValue: Property.isHiRes) }
        set { setAssociatedProperty(&Property.isHiRes, newValue: newValue) }
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
