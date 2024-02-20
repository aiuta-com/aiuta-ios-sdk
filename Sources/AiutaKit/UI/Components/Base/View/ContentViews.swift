//
// Created by nGrey on 28.02.2023.
//

import UIKit

protocol ContentView {
    var content: ContentBase? { get set }
}

open class PlainView: UIView, ContentView {
    weak var content: ContentBase?
    private var isAttached: Bool = false

    public required init() {
        super.init(frame: .zero)
    }

    override open func layoutSubviews() {
        content?.updateLayoutRecursive()
        updateShapeWithRoundedCorners()
    }

    override open func didMoveToWindow() {
        if window.isSome && !isAttached {
            isAttached = true
            content?.attached()
            content?.didAttach.fire()
        }

        if window.isNil && isAttached {
            isAttached = false
            content?.detached()
            content?.didDetach.fire()
        }
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

open class PlainImageView: UIImageView, ContentView {
    weak var content: ContentBase?
    private var isAttached: Bool = false

    override open func layoutSubviews() {
        updateShapeWithRoundedCorners()
    }

    override open func didMoveToWindow() {
        if window.isSome && !isAttached {
            isAttached = true
            content?.attached()
            content?.didAttach.fire()
        }

        if window.isNil && isAttached {
            isAttached = false
            content?.detached()
            content?.didDetach.fire()
        }
    }
}
