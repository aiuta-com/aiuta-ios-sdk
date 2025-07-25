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

@_spi(Aiuta) open class HScroll: Content<UIScrollView> {
    public var didScroll: Signal<(offset: CGFloat, delta: CGFloat)> { proxy.didScroll }
    public var didFinishScroll: Signal<Void> { proxy.didFinishScroll }
    public var willBeginDragging: Signal<Void> { proxy.willBeginDragging }
    public var didEndDragging: Signal<(velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)> { proxy.didEndDragging }

    public var contentInset: UIEdgeInsets {
        get { view.contentInset }
        set {
            guard view.contentInset != newValue else { return }
            view.contentInset = newValue
            view.contentOffset = .init(x: -newValue.left, y: 0)
        }
    }

    public var contentOffset: CGPoint {
        get { view.contentOffset }
        set {
            guard view.contentOffset != newValue else { return }
            view.contentOffset = newValue
        }
    }

    public var contentSize: CGSize {
        get { view.contentSize }
        set {
            guard view.contentSize != newValue else { return }
            view.contentSize = newValue
        }
    }

    public var itemSpace: CGFloat = 0 {
        didSet { updateLayoutInternal() }
    }

    public var flexibleHeight = true
    public var customLayout = false
    public var isLayoutEnabled = true

    private let proxy = ScrollDelegate()

    public convenience init(_ builder: (_ it: HScroll, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }

    public required init(view: UIScrollView) {
        super.init(view: view)
        applyDefaultConfiguration()
    }

    public required init() {
        super.init(view: IndirectScrollView())
        applyDefaultConfiguration()
    }

    private func applyDefaultConfiguration() {
        view.delegate = proxy
        view.alwaysBounceHorizontal = true
        view.alwaysBounceVertical = false
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
    }

    public func scroll(to focus: ContentBase, animated: Bool = true) {
        scroll(to: focus.layout.left + focus.layout.width / 2 - layout.width / 2, animated: animated)
    }

    public func scroll(to offset: CGFloat, animated: Bool = true, callback: (() -> Void)? = nil) {
        let tagetOffset = clamp(offset, min: view.horizontalOffsetForLeft, max: view.horizontalOffsetForRight)
        guard view.contentOffset.x != tagetOffset else {
            callback?()
            return
        }
        if let callback { proxy.didEndScrollingAnimation.subscribeOnce(with: self) { callback() } }
        view.setContentOffset(.init(x: tagetOffset, y: 0), animated: animated)
    }

    public func scrollToLeft(animated: Bool = true) {
        view.setContentOffset(.init(x: view.horizontalOffsetForLeft, y: 0), animated: animated)
    }

    public func scrollToRight(animated: Bool = true) {
        view.setContentOffset(.init(x: view.horizontalOffsetForRight, y: 0), animated: animated)
    }

    public func update() {
        updateLayoutRecursive()
    }

    override func updateLayoutInternal() {
        guard isLayoutEnabled else {
            proxy.scrollViewDidScroll(view)
            return
        }

        parent?.updateLayout()

        var upperContent: ContentBase?
        var rightPin: CGFloat = 0
        subcontents.forEach { content in
            content.updateLayout()
            content.layout.make { make in
                if flexibleHeight {
                    make.height = layout.height
                }
                if !customLayout {
                    if let upperContent {
                        make.left = upperContent.layout.rightPin + itemSpace
                    } else {
                        make.left = 0
                    }
                } else {
                    rightPin = max(rightPin, content.layout.rightPin)
                }
            }
            upperContent = content
        }
        if customLayout {
            view.contentSize = CGSize(width: rightPin > 0 ? rightPin : layout.width, height: layout.height)
        } else {
            view.contentSize = CGSize(width: upperContent?.layout.rightPin ?? layout.width, height: layout.height)
        }
        proxy.scrollViewDidScroll(view)
    }
}

private final class ScrollDelegate: NSObject, UIScrollViewDelegate {
    let didScroll = Signal<(offset: CGFloat, delta: CGFloat)>()
    let didFinishScroll = Signal<Void>()
    let willBeginDragging = Signal<Void>()
    let didEndDragging = Signal<(velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)>()
    let didEndScrollingAnimation = Signal<Void>()

    private var prevOffset: CGFloat = 0

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        nil
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x + scrollView.contentInset.left
        didScroll.fire((offset: offset, delta: offset - prevOffset))
        prevOffset = offset
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        willBeginDragging.fire()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        didEndDragging.fire((velocity, targetContentOffset))
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { didFinishScroll.fire() }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didFinishScroll.fire()
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        didEndScrollingAnimation.fire()
    }
}

@_spi(Aiuta) public extension UIScrollView {
    var isAtLeft: Bool {
        return contentOffset.x <= horizontalOffsetForLeft
    }

    var isAtRight: Bool {
        return contentOffset.x >= horizontalOffsetForRight
    }

    var horizontalOffsetForLeft: CGFloat {
        return -contentInset.left
    }

    var horizontalOffsetForRight: CGFloat {
        let scrollViewWidth = bounds.width
        let scrollContentSizeWidth = contentSize.width
        let rightInset = contentInset.right
        let scrollViewRightOffset = scrollContentSizeWidth + rightInset - scrollViewWidth
        return max(scrollViewRightOffset, -contentInset.left)
    }
}

public final class IndirectScrollView: UIScrollView, UIGestureRecognizerDelegate {
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = otherGestureRecognizer as? UIPanGestureRecognizer else { return false }
        let direction = pan.translation(in: nil)
        guard abs(direction.y) < abs(direction.x) else { return false }
        if (direction.x > 0 && isAtLeft) || (direction.x < 0 && isAtRight) {
            gestureRecognizer.cancel()
            return true
        }
        return false
    }
}
