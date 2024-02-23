//
//  Created by nGrey on 17.07.2023.
//

import UIKit

final class BulletinManager: PlainButton {
    weak var vc: UIViewController?

    let blur = Blur { it, _ in
        it.style = .dark
        it.intensity = 0.75
    }

    private(set) var currentBulletin: BulletinWrapper? {
        didSet {
            guard oldValue !== currentBulletin else { return }
            if let oldValue { hideWrapper(oldValue) }
            if let currentBulletin {
                showSelf()
                showWrapper(currentBulletin)
            } else {
                hideSelf()
            }
        }
    }

    private let cooldDownToken = AutoCancellationToken()
    private var canDismissByMisspan = false
    private var canDismissByMisstap = true {
        didSet {
            guard !canDismissByMisstap, oldValue != canDismissByMisstap else { return }
            cooldDownToken << delay(.halfOfSecond) { [self] in
                canDismissByMisstap = true
            }
        }
    }

    func showBulletin(_ content: PlainBulletin) {
        guard !content.isPresenting else { return }
        showBulletin(PlainBulletinWrapper(content: content))
    }

    func showBulletin(_ content: Bulletin) {
        guard !content.isPresenting else { return }
        currentBulletin = BulletinWrapper(content: content, presenter: vc)
    }

    override func setup() {
        view.pressedOpacity = nil
        
        onTouchDown.subscribe(with: self) { [unowned self] in
            guard canDismissByMisstap,
                  let current = currentBulletin, current.canDismissByMisstap
            else { return }

            canDismissByMisstap = false
            canDismissByMisspan = false
            current.contentView.dismiss()
        }
        
        onTouchUpInside.subscribe(with: self) { [unowned self] in
            canDismissByMisspan = true
        }

        gestures.onPan(.any, with: self) { [unowned self] pan in
            switch pan.state {
                case .ended, .cancelled, .failed:
                    canDismissByMisspan = true
                    return
                default: break
            }

            guard canDismissByMisstap, canDismissByMisspan,
                  let current = currentBulletin, current.canDismissByMisstap,
                  !current.contentView.view.bounds.contains(pan.location(in: current.contentView.view))
            else { return }

            canDismissByMisstap = false
            canDismissByMisspan = false
            current.contentView.dismiss()
        }
    }

    override func updateLayoutInternal() {
        layout.make { make in
            make.size = layout.boundary.size
        }

        blur.layout.make { make in
            make.size = layout.size
        }
    }

    init(viewController: UIViewController) {
        vc = viewController
        super.init()
    }

    required init() {
        fatalError("init() has not been implemented")
    }

    required init(view: TouchView) {
        fatalError("init(view:) has not been implemented")
    }
}

private extension BulletinManager {
    func showSelf() {
        guard parent.isNil, let vc,
              let ui = vc.viewAsUI
        else { return }
        blur.view.opacity = 0
        ui.addContent(self)
        updateLayoutInternal()
        blur.animations.opacityTo(1)
    }

    func hideSelf() {
        blur.animations.opacityTo(0) { [self] in
            guard currentBulletin.isNil else {
                blur.animations.opacityTo(1)
                return
            }
            removeFromParent()
        }
    }
}

private extension BulletinManager {
    func showWrapper(_ bulletin: BulletinWrapper) {
        bulletin.onDismiss.subscribe(with: self) { [unowned self] in
            currentBulletin = nil
        }

        addContent(bulletin)
        bulletin.updateLayoutRecursive()
        bulletin.isPreseting = true
    }

    func hideWrapper(_ bulletin: BulletinWrapper) {
        bulletin.onDismiss.cancelSubscription(for: self)
        bulletin.isPreseting = false
    }
}
