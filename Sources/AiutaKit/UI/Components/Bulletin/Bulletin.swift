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

@_spi(Aiuta) open class Bulletin: Scroll {
    public enum Behaviour {
        case dynamic, floating, fullscreen
    }

    private let _didDismiss = Signal<Void>()
    private let _willDismiss = Signal<Void>()
    private let _wantsDismiss = Signal<Void>()

    var wantsDismiss: Signal<Void> { _wantsDismiss }
    open var willDismiss: Signal<Void> { _willDismiss }
    open var didDismiss: Signal<Void> { _didDismiss }

    public private(set) weak var presenter: UIViewController?
    public private(set) var isPresenting: Bool = false

    public var behaviour: Behaviour = .dynamic
    public var isDismissableByPan = true

    public let blurStroke = Blur { it, _ in
        it.style = .extraLight
        it.appearance.make { make in
            make.isUserInteractionEnabled = false
        }
    }

    public let blurBody = Blur { it, _ in
        it.style = .extraLight
        it.appearance.make { make in
            make.isUserInteractionEnabled = false
        }
    }

    public let stroke = Stroke { it, _ in
        it.color = 0xD9D9D9FF.uiColor
    }

    public func dismiss() {
        wantsDismiss.fire()
    }

    open func canDismiss() -> Bool {
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

    public var blurHeight: CGFloat = 24

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
