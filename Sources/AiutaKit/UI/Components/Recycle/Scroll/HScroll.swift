//
//  Created by nGrey on 01.06.2023.
//

import UIKit

open class HScroll: Content<UIScrollView> {
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
        super.init(view: UIScrollView())
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

    public func scroll(to offset: CGFloat, animated: Bool = true) {
        view.setContentOffset(.init(x: clamp(offset, min: view.horizontalOffsetForLeft, max: view.horizontalOffsetForRight), y: 0), animated: animated)
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
}

public extension UIScrollView {
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
