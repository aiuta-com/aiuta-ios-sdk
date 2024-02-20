//
//  Created by nGrey on 30.05.2023.
//

import UIKit

open class PlainBulletin: Plane {
    let wantsDismiss = Signal<Void>()
    public let willDismiss = Signal<Void>()
    public let didDismiss = Signal<Void>(retainLastData: true)

    public internal(set) weak var presenter: UIViewController?
    public internal(set) var isPresenting: Bool = false

    public var hasStroke = true
    public var maxWidth: CGFloat?
    public var behaviour: Bulletin.Behaviour = .dynamic
    public var isDismissableByPan = true
    fileprivate var memColor: UIColor?

    override open func setup() {
        view.backgroundColor = ds.color.popup
    }

    public func dismiss() {
        wantsDismiss.fire()
    }

    open func canDismiss() -> Bool {
        true
    }

    public func dismiss() async {
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

@propertyWrapper public struct bulletin<ViewType> {
    public private(set) var wrappedValue: ViewType

    public init(wrappedValue: ViewType) {
        self.wrappedValue = wrappedValue
    }
}
