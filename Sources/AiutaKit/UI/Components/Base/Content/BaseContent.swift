//
// Created by nGrey on 24.02.2023.
//

import UIKit
import Resolver

open class Content<ViewType>: ContentBase where ViewType: UIView {
    public let view: ViewType
    override public var container: UIView! { view }

    public private(set) lazy var appearance = Appearance<ViewType>(view: view)

    public convenience init(_ builder: (_ it: Content<ViewType>, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }

    public required init(view: ViewType) {
        self.view = view
    }

    public required init() {
        view = ViewType()
    }
}

@MainActor open class ContentBase {
    public let onDeinit = Signal<ContentBase>()
    public let didAttach = Signal<Void>()
    public let didDetach = Signal<Void>()

    public private(set) var container: UIView!
    public private(set) var subcontents = [ContentBase]()

    @LazyInjected private var designSystem: DesignSystem
    public var ds: DesignSystem { designSystem }

    public private(set) weak var parent: ContentBase?
    public internal(set) var isRoot: Bool = false
    private var isSetUpAndChildrenAdded = false

    /// Public

    public private(set) lazy var layout = Layouts(self, target: container)
    public private(set) lazy var gestures = Gestures(target: container)
    public private(set) lazy var animations = Animations(target: container)
    public private(set) lazy var transitions = Transitions(target: container)

    public required init() {}

    deinit {
        onDeinit.fire(self)
    }

    /// Override

    open func setup() {}
    open func attached() {}
    open func detached() {}
    open func updateLayout() {}

    open func invalidateLayout() {
        if let parent { parent.invalidateLayout() }
        else { updateLayoutRecursive() }
    }

    func sizeToFit() {}
    func setupInternal() {
        if #available(iOS 13.0, *) {
            container.cornerCurve = .continuous
        }
    }
    func updateLayoutInternal() {}
    func inspectChild(_ child: Any) -> Bool { false }
}

public extension ContentBase {
    func addContent<ChildType>(_ content: ChildType, _ builder: (_ it: ChildType, _ ds: DesignSystem) -> Void) where ChildType: ContentBase {
        let child = addContent(content)
        builder(child, ds)
    }

    @discardableResult
    func addContent<ChildType>(_ content: ChildType) -> ChildType where ChildType: ContentBase {
        let oldParent = content.parent
        if oldParent.isSome { content.removeFromParent() }
        else { content.addChildren(to: content.container) }
        content.parent = self
        subcontents.append(content)
        container.addSubview(content.container)
        return content
    }

    func removeContent(_ content: ContentBase) {
        subcontents.removeAll { sub in sub === content }
        content.container.removeFromSuperview()
        content.parent = nil
    }

    func removeAllContents() {
        subcontents.forEach { sub in
            sub.container.removeFromSuperview()
        }
        subcontents.removeAll()
    }

    func removeFromParent() {
        parent?.removeContent(self)
        container.removeFromSuperview()
    }
}

public extension ContentBase {
    func bringToFront() {
        container.superview?.bringSubviewToFront(container)
    }

    func bringAbove(_ other: ContentBase) {
        guard let above = other.container else { return }
        container.superview?.insertSubview(container, aboveSubview: above)
    }

    func sendToBack() {
        container.superview?.sendSubviewToBack(container)
    }

    func sendBelow(_ other: ContentBase) {
        guard let below = other.container else { return }
        container.superview?.insertSubview(container, belowSubview: below)
    }
}

public extension ContentBase {
    func findChildren<ChildType>() -> [ChildType] {
        subcontents.compactMap { $0 as? ChildType }
    }

    func firstParentOfType<ParentType>() -> ParentType? {
        var candidate: ContentBase? = parent
        while candidate.isSome {
            if let test = candidate as? ParentType { return test }
            candidate = candidate?.parent
        }
        return nil
    }
}

internal extension ContentBase {
    func updateLayoutRecursive() {
        guard layout.isEnabled else { return }
        if container is UILabel {
            container.sizeToFit()
        }
        subcontents.forEach { $0.sizeToFit() }
        updateLayout()
        updateLayoutInternal()
        if subcontents.isEmpty { return }
        subcontents.forEach { $0.updateLayoutRecursive() }
        updateLayout()
        updateLayoutInternal()
    }
}

internal extension ContentBase {
    func addChildren(to container: UIView) {
        guard !isSetUpAndChildrenAdded else { return }
        if var observable = container as? ContentView { observable.content = self }
        addChildren(fromMirror: Mirror(reflecting: self), to: container)
        // TODO: container.masksToBounds = true
        isSetUpAndChildrenAdded = true
        setupInternal()
        setup()
    }

    private func addChildren(fromMirror mirror: Mirror, to container: UIView) {
        if let superclassMirror = mirror.superclassMirror {
            addChildren(fromMirror: superclassMirror, to: container)
        }
        for (property, value) in mirror.children {
            guard let property,
                  property != "parent",
                  property != "container",
                  property != "view"
            else { continue }
            addChild(value, to: container)
        }
    }

    private func addChild(_ child: Any, to container: UIView) {
        if inspectChild(child) { return }
        if let subView = child as? UIView {
            container.addSubview(subView)
        } else if let subContent = child as? ContentBase {
            subContent.parent = self
            subcontents.append(subContent)
            guard let subContainer = subContent.container else { return }
            subContent.addChildren(to: subContainer)
            container.addSubview(subContainer)
        }
    }
}
