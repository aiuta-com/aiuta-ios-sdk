//
//  Created by nGrey on 11.07.2023.
//

import Foundation
import Resolver
import UIKit

open class ComponentController<ViewContent>: ComponentControllerBase where ViewContent: ContentBase {
    public let ui: ViewContent

    public init(_ component: ViewContent) {
        ui = component
    }
}

@MainActor open class ComponentControllerBase {
    @Injected public private(set) var ds: DesignSystem
    public fileprivate(set) weak var vc: UIViewController?

    open func setup() {}
    open func start() async {}
}

public extension ComponentControllerBase {
    var navigationController: UINavigationController? {
        vc?.navigationController
    }

    func present(_ viewController: UIViewController) {
        vc?.present(viewController)
    }

    @discardableResult
    func showBulletin<T>(_ content: ResultBulletin<T>, untilDismissed: Bool = false, overrideVc: UIViewController? = nil) async -> T {
        guard let presenter = overrideVc ?? vc else { return content.defaultResult }
        return await presenter.showBulletin(content, untilDismissed: untilDismissed)
    }

    @discardableResult
    func showBulletin<B: PlainBulletin>(_ content: B) -> B {
        return vc?.showBulletin(content) ?? content
    }

    func showBulletin(_ content: Bulletin) {
        vc?.bulletinManager.showBulletin(content)
    }

    func showToast(_ title: String, subTitle: String? = nil, displayTime: TimeInterval = 1, attachTo view: UIView? = nil) {
        vc?.showToast(title, subTitle: subTitle, displayTime: displayTime, attachTo: view)
    }

    @discardableResult
    func addComponent<Component: ComponentControllerBase>(_ componentController: Component) -> Component {
        vc?.addComponent(componentController)
        return componentController
    }
}

public extension UIViewController {
    @discardableResult
    func addComponent<Component: ComponentControllerBase>(_ componentController: Component) -> Component {
        trace(i: "+", componentController, "-<", self)

        componentController.vc = self
        componentController.setup()
        Task { await componentController.start() }

        if componentControllers.isNil { componentControllers = [componentController] }
        else { componentControllers?.append(componentController) }

        return componentController
    }
}
