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

protocol ContentView {
    var content: ContentBase? { get set }
}

@_spi(Aiuta) open class PlainView: UIView, ContentView {
    weak var content: ContentBase?
    private var isAttached: Bool = false

    public required init() {
        super.init(frame: .zero)
    }

    override open func layoutSubviews() {
        guard let content, !content.willIgnoreNextLayout else {
            content?.willIgnoreNextLayout = false
            return
        }
        content.updateLayoutRecursive()
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

@_spi(Aiuta) open class PlainImageView: UIImageView, ContentView {
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
