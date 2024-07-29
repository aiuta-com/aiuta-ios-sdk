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

import Resolver
import UIKit

@_spi(Aiuta) public final class Snackbar<Body: Plane>: Plane {
    public let bar = Body()

    @scrollable
    public var placeholder = ScrollSpacer()

    public var isVisible = false {
        didSet {
            guard oldValue != isVisible else { return }
            view.isUserInteractionEnabled = isVisible
            placeholder.isVisible = isVisible
            animations.updateLayout()

            if let autoHideOnTime, isVisible {
                autoHideToken << delay(autoHideOnTime) { [weak self] in
                    self?.autoHide()
                }
            } else {
                autoHideToken.cancel()
            }
        }
    }

    public var autoHideOnSwipe = false {
        didSet {
            guard oldValue != autoHideOnSwipe else { return }
            if autoHideOnSwipe {
                bar.gestures.onSwipe(.down, with: self) { [unowned self] _ in
                    isVisible = false
                }
            } else {
                bar.gestures.offSwipe(.down, for: self)
            }
        }
    }

    public var autoHideOnTime: AsyncDelayTime?
    private var autoHideToken = AutoCancellationToken()

    public func show() {
        isVisible = true
    }

    public func hide() {
        isVisible = false
    }

    private func autoHide() {
        if #available(iOS 13.0, *) {
            Task { [weak self] in
                @Injected var heroic: Heroic
                await heroic.completeTransition()
                self?.isVisible = false
            }
        } else {
            isVisible = false
        }
    }

    override func setupInternal() {
        view.isUserInteractionEnabled = isVisible
        transitions.make { make in
            make.translate(y: 200)
            make.fade()
            make.global()
        }
    }

    public var bottomInset: CGFloat = 0 {
        didSet {
            transitions.make { make in
                make.translate(y: bottomInset + 200)
                make.fade()
                make.global()
            }
            guard oldValue != bottomInset, isVisible else { return }
            animations.updateLayout()
        }
    }

    override func updateLayoutInternal() {
        placeholder.height = bar.layout.height + 8

        layout.make { make in
            make.height = bar.layout.height
            make.width = min(600, layout.boundary.width - 32)
            make.centerX = 0
            make.bottom = isVisible ? max(bottomInset, layout.safe.insets.bottom) + 8 : -make.height
        }

        bar.layout.make { make in
            make.size = layout.size
            make.top = 0
        }
    }

    public convenience init(_ builder: (_ it: Snackbar<Body>, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }

    public final class ScrollSpacer: Plane {
        var isVisible = false {
            didSet {
                guard oldValue != isVisible else { return }
                animations.animate { [self] in
                    parentScroll?.update()
                }
            }
        }

        var height: CGFloat = 0 {
            didSet {
                guard oldValue != height else { return }
                parentScroll?.update()
            }
        }

        override func updateLayoutInternal() {
            layout.make { make in
                make.height = isVisible ? height : 0
            }
        }

        var parentScroll: VScroll? {
            firstParentOfType()
        }
    }
}
