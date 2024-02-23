//
//  Created by nGrey on 30.05.2023.
//

import UIKit

class PlainBulletin: Plane {
    let wantsDismiss = Signal<Void>()
    let willDismiss = Signal<Void>()
    let didDismiss = Signal<Void>(retainLastData: true)

    internal(set) weak var presenter: UIViewController?
    internal(set) var isPresenting: Bool = false

    var hasStroke = true
    var maxWidth: CGFloat?
    var behaviour: Bulletin.Behaviour = .dynamic
    var isDismissableByPan = true
    fileprivate var memColor: UIColor?

    override func setup() {
        view.backgroundColor = ds.color.popup
    }

    func dismiss() {
        wantsDismiss.fire()
    }

    func canDismiss() -> Bool {
        true
    }

    @available(iOS 13.0.0, *)
    func dismiss() async {
        wantsDismiss.fire()
        await withCheckedContinuation { continuation in
            didDismiss.subscribePastOnce(with: self) {
                continuation.resume()
            }
        }
    }
}

final class PlainBulletinWrapper: Bulletin {
    @scrollable
    var scrollContent: PlainBulletin

    override var wantsDismiss: Signal<Void> { scrollContent.wantsDismiss }
    override var willDismiss: Signal<Void> { scrollContent.willDismiss }
    override var didDismiss: Signal<Void> { scrollContent.didDismiss }

    required init(content: PlainBulletin) {
        scrollContent = content
        super.init()
    }

    override func setPresenter(_ presenter: UIViewController?) {
        scrollContent.presenter = presenter
        super.setPresenter(presenter)
    }

    override func setPresenting(_ isPresenting: Bool) {
        scrollContent.isPresenting = isPresenting
        super.setPresenting(isPresenting)
    }

    override func canDismiss() -> Bool {
        scrollContent.canDismiss()
    }

    override func setup() {
        view.backgroundColor = scrollContent.view.backgroundColor ?? scrollContent.memColor
        scrollContent.memColor = view.backgroundColor
        scrollContent.view.backgroundColor = nil
        if !scrollContent.hasStroke {
            stroke.view.isHidden = true
            blurStroke.view.isHidden = true
            blurBody.view.isHidden = true
        }
        maxWidth = scrollContent.maxWidth
        behaviour = scrollContent.behaviour
        isDismissableByPan = scrollContent.isDismissableByPan
    }

    required init(view: PlainView) {
        fatalError("init(view:) has not been implemented")
    }

    required init() {
        fatalError("init() has not been implemented")
    }
}

@propertyWrapper struct bulletin<ViewType> {
    private(set) var wrappedValue: ViewType

    init(wrappedValue: ViewType) {
        self.wrappedValue = wrappedValue
    }
}
