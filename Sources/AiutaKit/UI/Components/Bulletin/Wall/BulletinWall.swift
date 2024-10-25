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

@_spi(Aiuta) public class BulletinWall: PlainButton {
    public weak static var current: BulletinWall? {
        didSet { oldValue?.dismiss() }
    }

    private let presentingAlphaChangeDuration: AsyncDelayTime = .custom(0.4)

    public var intence: CGFloat = 0 {
        didSet {
            let tail = UIViewController.isStackingAllowed ? 0.6 : 0.2
            view.opacity = darkness + clamp(intence, min: 0, max: 1) * tail
        }
    }

    private var level: CGFloat = -1 {
        willSet {
            oldAdjustedLevel = adjustedLevel
        }
        didSet {
            guard oldValue != level else { return }
            let d: CGFloat = UIViewController.isStackingAllowed ? 0.6 : 0.4
            let l = adjustedLevel
            darkness = l > 0 ? pow(d, 1 / max(1, l)) : 0
        }
    }

    private var adjustedLevel: CGFloat {
        UIViewController.isStackingAllowed ? level - 1 : level
    }

    private var oldAdjustedLevel: CGFloat = 0

    private var darkness: CGFloat = 0 {
        didSet {
            let isFast = UIViewController.isStackingAllowed || adjustedLevel > 1 || oldAdjustedLevel > 1
            animations.animate(time: isFast ? .quarterOfSecond : presentingAlphaChangeDuration) { [self] in
                intence = 0
            }
        }
    }

    public convenience init?(injectingTo parent: UIView?) {
        guard let parent else { return nil }
        self.init()

        BulletinWall.current = self
        view.isMaxOpaque = false
        view.backgroundColor = .black

        onTouchDown.subscribe(with: view) { [self] in
            dismiss()
        }

        parent.addSubview(container)
        updateLayoutRecursive()
        level = 0
    }

    public func increase(max: Int? = nil) {
        if let max, level + 1 > CGFloat(max) { return }
        level += 1
    }

    public func reduce(to: Int? = nil) {
        if let to { level = CGFloat(to) }
        else { level = max(0, level - 1) }
    }

    public func dismiss() {
        onTouchDown.cancelSubscription(for: view)
        animations.opacityTo(0, time: presentingAlphaChangeDuration) { [container] in
            container?.removeFromSuperview()
        }
    }

    override func updateLayoutInternal() {
        layout.make { make in
            make.inset = 0
        }
    }
}
