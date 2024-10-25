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

final class BulletinWrapper: Plane {
    let onDismiss = Signal<Void>()

    public let floatingContainer = Plane()

    @scrollable
    public var contentView: Bulletin

    init(content: Bulletin, presenter: UIViewController?) {
        contentView = content

        super.init()

        contentView.setPresenter(presenter)

        contentView.appearance.make { make in
            make.cornerRadius = 24
            if #available(iOS 13.0, *) {
                make.cornerCurve = .continuous
            }
            make.backgroundColor = ds.color.popup
        }

        contentView.scrollView.contentInset = .init(vertical: contentView.view.cornerRadius)

        contentView.wantsDismiss.subscribe(with: self) { [unowned self] in
            guard contentView.canDismiss() else { return }
            contentView.wantsDismiss.cancelSubscription(for: self)
            delay(.moment) { [self] in onDismiss.fire() }
        }
    }

    var isPreseting = false {
        didSet {
            guard oldValue != isPreseting else { return }

            willHideOnEndDrag = false

            if isPreseting { updateLayoutRecursive() }
            contentView.setPresenting(isPreseting)
            if !isPreseting { contentView.willDismiss.fire() }

            appearance.make { $0.isUserInteractionEnabled = isPreseting }

            willAnimateLayoutUpdates = false

            let animation = { [self] in
                appearingPercent = isPreseting ? 1 : 0
            }

            let finalization = { [self] in
                willAnimateLayoutUpdates = true
                if !isPreseting {
                    removeFromParent()
                    contentView.didDismiss.fire()
                    contentView.appearance.unfreeze()
                } else {
                    // This hack will prevent unwanted deafult scroll behaviour on top...
                    contentView.scrollView.view.setContentOffset(.init(x: 0, y: contentView.scrollView.view.verticalOffsetForTop + 1), animated: false)
                }
            }

            if isPreseting {
                animations.animate(dampingRatio: 0.8, time: 0.5, changes: animation, complete: finalization)
            } else {
                contentView.appearance.freeze()
                animations.animate(time: .quarterOfSecond, changes: animation, complete: finalization)
            }
        }
    }

    private var willHideOnEndDrag = false
    private var willDectecHideOnDrag = true
    var canDismissByMisstap: Bool {
        contentView.isDismissableByPan
    }

    private var appearingPercent: CGFloat = 0 {
        didSet {
            guard oldValue != appearingPercent else { return }
            updateLayoutInternal()
        }
    }

    private var scrollOffset: CGFloat = 0 {
        didSet {
            guard oldValue != scrollOffset else { return }
            updateLayoutInternal()
        }
    }

    override func setup() {
        contentView.scrollView.isSystemBehaviorOnTopEnabled = false

        contentView.scrollView.didChangeOffset.subscribe(with: self) { [unowned self] offset, delta in
            guard isPreseting else { return }
            if contentView.behaviour == .floating {
                contentView.appearance.freeze()
                scrollOffset = offset
            } else {
                scrollOffset = min(0, offset)
            }
            willHideOnEndDrag = willDectecHideOnDrag && contentView.isDismissableByPan && scrollOffset <= -20 && delta < 0
            if willHideOnEndDrag && !contentView.canDismiss() {
                willDectecHideOnDrag = false
                willHideOnEndDrag = false
            }
        }

        contentView.scrollView.didEndDragging.subscribe(with: self) { [unowned self] _, _ in
            willDectecHideOnDrag = true
            if willHideOnEndDrag { contentView.dismiss() }
        }

        contentView.scrollView.didFinishScroll.subscribe(with: self) { [unowned self] in
            if contentView.behaviour == .floating {
                contentView.appearance.unfreeze()
            }
        }

        floatingContainer.addContent(contentView)
    }

    override func invalidateLayout() {
        willAnimateLayoutUpdates = true
        updateLayoutRecursive()
        willAnimateLayoutUpdates = false
    }

    private var willAnimateLayoutUpdates = false

    override func updateLayoutInternal() {
        var isFloating: Bool = false
        var isFullscreen: Bool = false

        switch contentView.behaviour {
            case .dynamic: break
            case .floating: isFloating = true
            case .fullscreen: isFullscreen = true
        }

        contentView.layout.make { make in
            make.radius = isFloating ? contentView.cornerRadius * 1.5 : contentView.cornerRadius
        }

        layout.make { make in
            make.size = layout.boundary.size
            if isFloating { make.leftRight = 16 }
            if make.width > 500 { make.width -= 100 }
            if let maxWidth = contentView.maxWidth {
                make.width = min(make.width, maxWidth)
            }
            make.centerX = 0
        }

        let targetHeight: CGFloat
        if isFullscreen {
            targetHeight = layout.height - layout.safe.insets.top
        } else {
            targetHeight = min(layout.height - layout.safe.insets.top - 30,
                               contentView.scrollView.contentSize.height +
                                   contentView.scrollView.contentInset.verticalInsetsSum +
                                   (isFloating ? 0 : layout.safe.insets.bottom))
        }

        floatingContainer.layout.make { make in
            let floatingOffset = layout.height - targetHeight
            make.size = layout.size
            make.top = isFloating ? -floatingOffset / 2 : 0
        }

        let needAnimate = willAnimateLayoutUpdates && (targetHeight != contentView.layout.height)
        animations.animate(time: needAnimate ? .quarterOfSecond : .instant) { [self] in
            contentView.layout.make { make in
                make.centerX = 0
                make.width = layout.width
                make.height = targetHeight
                make.bottom = -contentView.view.cornerRadius - make.height * (1 - appearingPercent) + scrollOffset
            }
        }

        contentView.scrollOffset = scrollOffset
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    required init(view: PlainView) {
        fatalError("init(view:) has not been implemented")
    }
}
