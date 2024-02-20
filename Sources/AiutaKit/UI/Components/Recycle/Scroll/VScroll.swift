//
//  Created by nGrey on 20.04.2023.
//

import UIKit

open class VScroll: Content<UIScrollView> {
    public var didScroll: Signal<ScrollInfo> { proxy.didScroll }
    public var didChangeOffset: Signal<(offset: CGFloat, delta: CGFloat)> { proxy.didChangeOffset }
    public var didFinishScroll: Signal<Void> { proxy.didFinishScroll }
    public var willBeginDragging: Signal<Void> { proxy.willBeginDragging }
    public var didEndDragging: Signal<(velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)> { proxy.didEndDragging }

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

    public required init(view: UIScrollView) {
        super.init(view: view)
        applyDefaultConfiguration()
    }

    public required init() {
        super.init(view: UIScrollView())
        applyDefaultConfiguration()
    }

    private func applyDefaultConfiguration() {
        view.delegate = proxy
        view.alwaysBounceVertical = true
        view.contentInsetAdjustmentBehavior = .never
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
    }

    public func scroll(to sub: ContentBase, animated: Bool = false) {
        view.setContentOffset(.init(x: 0, y: sub.container.frame.origin.y), animated: animated)
    }

    public func scroll(to point: CGPoint, animated: Bool = true) {
        view.setContentOffset(point, animated: animated)
    }

    public func scroll(to offset: CGFloat, animated: Bool = true) {
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

public struct ScrollInfo {
    public let offset: CGFloat
    public let relativeOffet: CGFloat
    public let delta: CGFloat
    public let pullDown: CGFloat
    public let withTouch: Bool
}

private final class ScrollDelegate: NSObject, UIScrollViewDelegate {
    let didScroll = Signal<ScrollInfo>(retainLastData: true)
    let didChangeOffset = Signal<(offset: CGFloat, delta: CGFloat)>(retainLastData: true)
    let didFinishScroll = Signal<Void>()
    let willBeginDragging = Signal<Void>()
    let didEndDragging = Signal<(velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)>()

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
            delta: offset - prevOffset,
            pullDown: -offset,
            withTouch: isTouching
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
}

public extension UIScrollView {
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
