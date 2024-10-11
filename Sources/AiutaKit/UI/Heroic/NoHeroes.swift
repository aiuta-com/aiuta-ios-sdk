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

@_spi(Aiuta) public final class NoHeroes: Heroic {
    public var isTransitioning: Bool { false }
    public let willStartTransition = Signal<Void>()
    public let didCompleteTransition = Signal<Void>()

    @available(iOS 13.0.0, *)
    public func completeTransition() async {}

    public func setEnabled(_ value: Bool, for vc: UIViewController) {}

    public func customize(for vc: UIViewController) {}

    public func setId(_ value: String?, for view: UIView) {}

    public func setModifiers(_ value: [TransitionMaker]?, for view: UIView) {}

    public func copyAnimation(from: UIViewController, to navigationController: UINavigationController?) {}

    public func replace(_ viewController: UIViewController, with next: UIViewController) {
        if let navigationController = viewController.navigationController {
            var vcs = navigationController.children
            if !vcs.isEmpty {
                vcs.removeLast()
                vcs.append(next)
            }
            navigationController.setViewControllers(vcs, animated: true)
        }
    }

    public func update(percent: CGFloat) {}

    public func finish(animate: Bool) {}

    public func cancel(animate: Bool) {}

    public init() {}
}
