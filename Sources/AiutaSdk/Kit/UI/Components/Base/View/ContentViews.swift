//
// Created by nGrey on 28.02.2023.
//

import UIKit

protocol ContentView {
    var content: ContentBase? { get set }
}

class PlainView: UIView, ContentView {
    weak var content: ContentBase?
    private var isAttached: Bool = false

    required init() {
        super.init(frame: .zero)
    }

    override func layoutSubviews() {
        content?.updateLayoutRecursive()
        updateShapeWithRoundedCorners()
    }

    override func didMoveToWindow() {
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PlainImageView: UIImageView, ContentView {
    weak var content: ContentBase?
    private var isAttached: Bool = false

    override func layoutSubviews() {
        updateShapeWithRoundedCorners()
    }

    override func didMoveToWindow() {
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
