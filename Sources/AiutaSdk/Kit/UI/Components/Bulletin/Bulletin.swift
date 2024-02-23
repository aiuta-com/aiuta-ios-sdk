//
//  Created by nGrey on 29.05.2023.
//

import UIKit

class Bulletin: Scroll {
    enum Behaviour {
        case dynamic, floating, fullscreen
    }

    private let _didDismiss = Signal<Void>()
    private let _willDismiss = Signal<Void>()
    private let _wantsDismiss = Signal<Void>()

    var wantsDismiss: Signal<Void> { _wantsDismiss }
    var willDismiss: Signal<Void> { _willDismiss }
    var didDismiss: Signal<Void> { _didDismiss }

    private(set) weak var presenter: UIViewController?
    private(set) var isPresenting: Bool = false

    var behaviour: Behaviour = .dynamic
    var isDismissableByPan = true

    let blurStroke = Blur { it, _ in
        it.style = .extraLight
        it.appearance.make { make in
            make.isUserInteractionEnabled = false
        }
    }

    let blurBody = Blur { it, _ in
        it.style = .extraLight
        it.appearance.make { make in
            make.isUserInteractionEnabled = false
        }
    }

    let stroke = Stroke { it, _ in
        it.color = 0xD9D9D9FF.uiColor
    }

    func dismiss() {
        wantsDismiss.fire()
    }

    func canDismiss() -> Bool {
        true
    }

    internal func setPresenting(_ isPresenting: Bool) {
        self.isPresenting = isPresenting
    }

    internal func setPresenter(_ presenter: UIViewController?) {
        self.presenter = presenter
    }

    internal var scrollOffset: CGFloat = 0 {
        didSet { updateLayoutInternal() }
    }

    var blurHeight: CGFloat = 24

    override func updateLayoutInternal() {
        if behaviour == .floating {
            stroke.view.isHidden = true
            blurStroke.view.isHidden = true
            blurBody.view.isHidden = true
        }

        blurStroke.layout.make { make in
            make.width = layout.width
            make.height = blurHeight
        }

        blurBody.layout.make { make in
            make.width = layout.width
            make.top = blurStroke.layout.bottomPin
            make.bottom = 0
        }

        stroke.layout.make { make in
            make.size = .init(width: 30, height: 3)
            make.radius = 1.5
            make.centerX = 0
            make.top = 8
        }

        scrollView.layout.make { make in
            make.size = layout.size
            make.top = scrollOffset
        }
    }
}
