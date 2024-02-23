//
//  Created by nGrey on 01.06.2023.
//

import UIKit

final class Spinner: Content<UIActivityIndicatorView> {
    var isSpinning = true {
        didSet {
            guard oldValue != isSpinning else { return }
            updateState()
        }
    }

    var style: UIActivityIndicatorView.Style {
        get { view.style }
        set { view.style = newValue }
    }

    convenience init(_ builder: (_ it: Spinner, _ ds: DesignSystem) -> Void) {
        self.init()
        if #available(iOS 13.0, *) {
            view.style = .medium
        }
        builder(self, ds)
    }

    override func setup() {
        updateState()
    }

    private func updateState() {
        if isSpinning { view.startAnimating() }
        else { view.stopAnimating() }
    }

    var imageSize: CGSize {
        let imgView = view.subviews.first { $0 is UIImageView }
        return imgView?.bounds.size ?? .zero
    }

    override func updateLayoutInternal() {
        layout.make { make in
            make.size = imageSize
        }
    }
}
