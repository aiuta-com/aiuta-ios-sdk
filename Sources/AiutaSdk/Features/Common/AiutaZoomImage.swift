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

final class ZoomImage: Content<UIScrollView> {
    let didZoom = Signal<CGFloat?>()
    let onDismiss = Signal<Void>()
    let mayDismiss = Signal<Bool>()

    var index: Int = 0

    @scrollable
    var imageView = Image { it, _ in
        it.isAutoSize = false
        it.contentMode = .scaleAspectFill
    }

    var verticalFitInset: CGFloat = 0 {
        didSet {
            guard oldValue != verticalFitInset else { return }
            setImageSize()
            updateInsets()
        }
    }

    private let delegate = ZoomDelegate()
    private var isLayedOut = false

    override func setup() {
        view.addSubview(imageView.container)
        delegate.viewForZoom = imageView.view
        delegate.zoomImage = self
        appearance.make { make in
            make.minimumZoomScale = 1
            make.maximumZoomScale = 2
            make.alwaysBounceVertical = true
            make.alwaysBounceHorizontal = false
            make.showsVerticalScrollIndicator = false
            make.showsHorizontalScrollIndicator = false
            make.contentInsetAdjustmentBehavior = .never
            make.decelerationRate = .fast
            make.delegate = delegate
            make.backgroundColor = .clear
        }
        imageView.transitions.make { make in
            make.noFade()
        }
        imageView.gotImage.subscribe(with: self) { [unowned self] in
            setImageSize()
            updateInsets()
        }
        gestures.onDoubleTap(with: self) { [unowned self] tap in
            guard tap.state == .ended else { return }
            toggleZoom()
        }
    }

    override func updateLayout() {
        guard layout.height > 0, !isLayedOut, imageView.image.isSome else { return }
        setImageSize()
        updateInsets()
    }

    private func setImageSize() {
        guard layout.height > 0, var imageSize = imageView.image?.size else { return }
        let imageScale = layout.height / imageSize.height
        imageSize = imageSize * imageScale

        view.minimumZoomScale = 1
        view.maximumZoomScale = 2
        view.zoomScale = 1
        view.contentSize = .zero
        view.contentInset = .zero
        view.contentOffset = .zero

        imageView.view.frame = .init(size: imageSize)
        view.contentSize = imageSize
        view.minimumZoomScale = min(layout.width / imageSize.width, (layout.height - 2 * verticalFitInset) / imageSize.height) - 0.005
        view.maximumZoomScale = max(layout.width / imageSize.width, layout.height / imageSize.height) * 1.5
        view.zoomScale = view.minimumZoomScale
        let indentHorizontal = (layout.width - imageView.layout.frame.width) / 2
        let indentVertical = (layout.height - imageView.layout.frame.height) / 2
        view.setContentOffset(.init(x: -indentHorizontal, y: -indentVertical), animated: false)

        isLayedOut = true
    }

    fileprivate func updateInsets() {
        var indentHorizontal = (layout.width - imageView.layout.frame.width) / 2
        var indentVertical = (layout.height - imageView.layout.frame.height) / 2
        indentHorizontal = indentHorizontal > 0 ? indentHorizontal : 0
        indentVertical = indentVertical > 0 ? indentVertical : 0
        view.contentInset = UIEdgeInsets(top: indentVertical,
                                         left: indentHorizontal,
                                         bottom: indentVertical,
                                         right: indentHorizontal)

        if view.zoomScale <= view.minimumZoomScale {
            didZoom.fire(nil)
        } else {
            didZoom.fire(view.zoomScale)
        }
    }

    private func toggleZoom() {
        if view.minimumZoomScale < 0.9 {
            toggleToMinZoom()
        } else {
            toggleToMaxZoom()
        }
    }

    private func toggleToMinZoom() {
        if view.zoomScale > view.minimumZoomScale {
            view.setZoomScale(view.minimumZoomScale, animated: true)
        } else {
            view.setZoomScale(1, animated: true)
        }
    }

    private func toggleToMaxZoom() {
        if view.zoomScale < view.maximumZoomScale {
            view.setZoomScale(view.maximumZoomScale, animated: true)
        } else {
            view.setZoomScale(1, animated: true)
        }
    }

    convenience init(_ builder: (_ it: ZoomImage, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}

private final class ZoomDelegate: NSObject, UIScrollViewDelegate {
    weak var viewForZoom: UIView?
    weak var zoomImage: ZoomImage?

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        viewForZoom
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        zoomImage?.updateInsets()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        zoomImage?.mayDismiss.fire(scrollViewMayDismiss(scrollView))
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollViewMayDismiss(scrollView) { zoomImage?.onDismiss.fire() }
    }

    func scrollViewMayDismiss(_ scrollView: UIScrollView) -> Bool {
        let z = scrollView.zoomScale, mn = scrollView.minimumZoomScale, mx = scrollView.maximumZoomScale
        guard z >= mn else { return false }
        let offsetToDissmiss: CGFloat = 30 * pow(1 + (z - mn) / (mx - mn), 2)
        if scrollView.contentOffset.y + scrollView.contentInset.top < -offsetToDissmiss {
            return true
        } else if scrollView.contentOffset.y > scrollView.verticalOffsetForBottom + offsetToDissmiss {
            return true
        }
        return false
    }
}
