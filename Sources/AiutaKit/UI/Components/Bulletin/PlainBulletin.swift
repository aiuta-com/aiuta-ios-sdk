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

@_spi(Aiuta) open class PlainBulletin: Plane {
    let wantsDismiss = Signal<Void>()
    public let willDismiss = Signal<Void>()
    public let didDismiss = Signal<Void>(retainLastData: true)

    public internal(set) weak var presenter: UIViewController?
    public internal(set) var isPresenting: Bool = false

    public var hasStroke = true
    public var strokeWidth: CGFloat = 36
    public var strokeOffset: CGFloat = 6
    public var maxWidth: CGFloat?
    public var cornerRadius: CGFloat = 24
    public var behaviour: Bulletin.Behaviour = .dynamic
    open var dim: Bulletin.Dim { .blackout(0.5) }
    public var isDismissableByPan = true
    fileprivate var memColor: UIColor?

    override open func setup() {
        view.backgroundColor = ds.kit.popup
    }

    public func dismiss() {
        wantsDismiss.fire()
    }

    open func canDismiss() -> Bool {
        true
    }

    @available(iOS 13.0.0, *)
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

    override var dim: Bulletin.Dim { scrollContent.dim }

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
        blurStroke.color = view.backgroundColor ?? .clear
        scrollContent.memColor = view.backgroundColor
        scrollContent.view.backgroundColor = nil
        if !scrollContent.hasStroke {
            stroke.view.isHidden = true
            blurStroke.view.isHidden = true
        }
        maxWidth = scrollContent.maxWidth
        cornerRadius = scrollContent.cornerRadius
        strokeWidth = scrollContent.strokeWidth
        strokeOffset = scrollContent.strokeOffset
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

@propertyWrapper @_spi(Aiuta) public struct bulletin<ViewType> {
    public private(set) var wrappedValue: ViewType

    public init(wrappedValue: ViewType) {
        self.wrappedValue = wrappedValue
    }
}
