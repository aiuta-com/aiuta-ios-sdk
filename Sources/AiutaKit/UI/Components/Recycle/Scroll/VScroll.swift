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

@_spi(Aiuta) open class VScroll: Content<TapThroughScrollView> {
    public var didScroll: Signal<ScrollInfo> { proxy.didScroll }
    public var didChangeOffset: Signal<(offset: CGFloat, delta: CGFloat)> { proxy.didChangeOffset }
    public var didFinishScroll: Signal<Void> { proxy.didFinishScroll }
    public var willBeginDragging: Signal<Void> { proxy.willBeginDragging }
    public var willScrollToTop: Signal<Void> { proxy.willScrollToTop }
    public var didEndDragging: Signal<(velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)> { proxy.didEndDragging }
    public var willScrollToOffset = Signal<CGFloat>()
    public var didEndScrollingAnimation: Signal<Void> { proxy.didEndScrollingAnimation }

    public var topInset: CGFloat = 0 {
        didSet {
            guard topInset != oldValue else { return }
            view.contentInset = .init(top: topInset, bottom: view.contentInset.bottom)
            view.contentOffset = .init(x: 0, y: -topInset)
        }
    }

    public var contentInset: UIEdgeInsets {
        get { view.contentInset }
        set {
            guard view.contentInset != newValue else { return }
            view.contentInset = newValue
            view.contentOffset = .init(x: 0, y: -newValue.top)
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

    public var fastDeceleration: Bool {
        get { view.decelerationRate == .fast }
        set {
            guard fastDeceleration != newValue else { return }
            view.decelerationRate = newValue ? .fast : .normal
        }
    }

    public var itemSpace: CGFloat = 0 {
        didSet { updateLayoutInternal() }
    }

    public var tapThroughTopInset: CGFloat? {
        get { view.tapThroughTopInset }
        set { view.tapThroughTopInset = newValue }
    }

    public var isLayoutEnabled = true
    public var flexibleWidth = true
    public var customLayout = false
    public var keepAtBottom = false
    private var wasAtBottom = false

    private let proxy = ScrollDelegate()

    public convenience init(_ builder: (_ it: VScroll, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }

    public required init(view: TapThroughScrollView) {
        super.init(view: view)
        applyDefaultConfiguration()
    }

    public required init() {
        super.init(view: TapThroughScrollView())
        applyDefaultConfiguration()
    }

    private func applyDefaultConfiguration() {
        view.delegate = proxy
        view.alwaysBounceVertical = true
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
    }

    public func scroll(to focus: ContentBase, animated: Bool = true) {
        scroll(to: .init(x: 0, y: focus.layout.top + focus.layout.height / 2 - layout.height / 2), animated: animated)
    }

    public func scroll(to point: CGPoint, animated: Bool = true) {
        scroll(to: point.y, animated: animated)
    }

    public func scroll(to offset: CGFloat, animated: Bool = true) {
        willScrollToOffset.fire(offset)
        view.setContentOffset(.init(x: 0, y: clamp(offset, min: view.verticalOffsetForTop, max: view.verticalOffsetForBottom)), animated: animated)
    }

    public func scrollToTop(animated: Bool = true) {
        view.setContentOffset(.init(x: 0, y: view.verticalOffsetForTop), animated: animated)
    }

    public func scrollToBottom(animated: Bool = true) {
        view.setContentOffset(.init(x: 0, y: view.verticalOffsetForBottom), animated: animated)
    }

    public func update() {
        updateLayoutRecursive()
    }

    override func updateLayoutInternal() {
        guard isLayoutEnabled else {
            return
        }

        parent?.updateLayout()

        var upperContent: ContentBase?
        var bottomPin: CGFloat = 0
        subcontents.forEach { content in
            guard content.container.isVisible else { return }
            content.layout.make { make in
                if flexibleWidth {
                    make.left = content.layout.insets.left
                    make.right = content.layout.insets.right
                }
                if !customLayout {
                    if let upperContent {
                        make.top = upperContent.layout.insets.bottom + upperContent.layout.bottomPin + itemSpace
                    } else {
                        make.top = 0
                    }
                    make.top += content.layout.insets.top
                } else {
                    bottomPin = max(bottomPin, content.layout.bottomPin)
                }
            }
            upperContent = content
        }
        let newSize: CGSize
        if customLayout {
            newSize = CGSize(width: layout.width, height: bottomPin > 0 ? bottomPin : layout.height)
        } else {
            newSize = CGSize(width: layout.width, height: upperContent?.layout.bottomPin ?? layout.height)
        }
        if newSize != view.contentSize {
            view.contentSize = newSize
            proxy.scrollViewDidScroll(view)
        }

        if keepAtBottom, wasAtBottom, !view.isAtBottom, !proxy.isTouching {
            view.setContentOffset(.init(x: 0, y: view.verticalOffsetForBottom), animated: false)
            wasAtBottom = true
        } else {
            wasAtBottom = view.isAtBottom
        }
    }
}

@_spi(Aiuta) public struct ScrollInfo {
    public let offset: CGFloat
    public let relativeOffet: CGFloat
    public let startOffset: CGFloat
    public let delta: CGFloat
    public let pullDown: CGFloat
    public let withTouch: Bool
    public let isAtTop: Bool
    public let isAtBottom: Bool
    public let maxScroll: CGFloat
}

private final class ScrollDelegate: NSObject, UIScrollViewDelegate {
    let didScroll = Signal<ScrollInfo>(retainLastData: true)
    let didChangeOffset = Signal<(offset: CGFloat, delta: CGFloat)>(retainLastData: true)
    let didFinishScroll = Signal<Void>()
    let willBeginDragging = Signal<Void>()
    let willScrollToTop = Signal<Void>()
    let didEndDragging = Signal<(velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)>()
    let didEndScrollingAnimation = Signal<Void>()

    private var prevOffset: CGFloat = 0
    private var startOffset: CGFloat = 0
    var isTouching: Bool = false

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        nil
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + scrollView.contentInset.top
        didChangeOffset.fire((offset: offset, delta: offset - prevOffset))
        didScroll.fire(.init(
            offset: offset,
            relativeOffet: offset - startOffset,
            startOffset: startOffset,
            delta: offset - prevOffset,
            pullDown: -offset,
            withTouch: isTouching,
            isAtTop: scrollView.isAtTop,
            isAtBottom: scrollView.isAtBottom,
            maxScroll: scrollView.contentSize.height + scrollView.contentInset.verticalInsetsSum - scrollView.bounds.height
        ))
        prevOffset = offset
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        isTouching = true
        willBeginDragging.fire()
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        didEndDragging.fire((velocity, targetContentOffset))
        isTouching = false
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate { didFinishScroll.fire() }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didFinishScroll.fire()
    }

    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        willScrollToTop.fire()
        return true
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        didEndScrollingAnimation.fire()
    }
}

@_spi(Aiuta) public extension UIScrollView {
    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }

    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }

    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }

    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return max(scrollViewBottomOffset, -contentInset.top)
    }
}

public final class TapThroughScrollView: UIScrollView {
    public var tapThroughTopInset: CGFloat?

    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let tapThroughTopInset, point.y < -tapThroughTopInset else {
            return super.point(inside: point, with: event)
        }

        return false
    }
}
