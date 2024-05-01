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

@_spi(Aiuta) public final class Spinner: Content<UIActivityIndicatorView> {
    public var isSpinning = true {
        didSet {
            guard oldValue != isSpinning else { return }
            updateState()
        }
    }

    public var style: UIActivityIndicatorView.Style {
        get { view.style }
        set { view.style = newValue }
    }

    public convenience init(_ builder: (_ it: Spinner, _ ds: DesignSystem) -> Void) {
        self.init()
        if #available(iOS 13.0, *) {
            view.style = .medium
        }
        builder(self, ds)
    }

    override public func setup() {
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
