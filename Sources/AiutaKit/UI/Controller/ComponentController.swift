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

import Foundation
import Resolver
import UIKit

@_spi(Aiuta) open class ComponentController<ViewContent>: ComponentControllerBase where ViewContent: ContentBase {
    public let ui: ViewContent

    public init(_ component: ViewContent) {
        ui = component
    }
}

@MainActor @_spi(Aiuta) open class ComponentControllerBase {
    @Injected public private(set) var ds: DesignSystem
    public fileprivate(set) weak var vc: UIViewController?

    open func setup() {}
        open func start() async {}
}

@_spi(Aiuta) public extension ComponentControllerBase {
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

    @discardableResult
    func addComponent<Component: ComponentControllerBase>(_ componentController: Component) -> Component {
        vc?.addComponent(componentController)
        return componentController
    }

        @discardableResult
    func share(image: UIImage, title: String? = nil, additions: [Any] = []) async -> ShareResult {
        if let vc { return await vc.share(image: image, title: title, additions: additions) }
        else { return .failed(activity: nil, error: ShareError("No view controller to share")) }
    }

        @discardableResult
    func share(images: [UIImage], title: String? = nil, additions: [Any] = []) async -> ShareResult {
        if let vc { return await vc.share(images: images, title: title, additions: additions) }
        else { return .failed(activity: nil, error: ShareError("No view controller to share")) }
    }
}

@_spi(Aiuta) public extension UIViewController {
    @discardableResult
    func addComponent<Component: ComponentControllerBase>(_ componentController: Component) -> Component {
        trace(i: "+", componentController, "-<", self)

        componentController.vc = self
        componentController.setup()
        if #available(iOS 13.0, *) {
            Task { await componentController.start() }
        }

        if componentControllers.isNil { componentControllers = [componentController] }
        else { componentControllers?.append(componentController) }

        return componentController
    }
}
