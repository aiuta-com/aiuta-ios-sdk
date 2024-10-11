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

import PhotosUI
import Resolver
import UIKit

@_spi(Aiuta) public extension UIViewController {
    static var isStackingAllowed: Bool = true

    func replace(with viewController: UIViewController, backstack: UIViewController? = nil) {
        if let bctrl = viewController as? BulletinController {
            bctrl.presenter = self
            if let bulletin = bctrl.bulletin {
                showBulletin(bulletin)
            }
            return
        }

        @Injected var heroic: Heroic
        heroic.finish(animate: false)

        whenPushback()

        heroic.copyAnimation(from: viewController, to: navigationController)
        viewController.backstackController = backstack

        guard let navigationController else {
            heroic.replace(self, with: viewController)
            return
        }

        if navigationController.viewControllers.contains(viewController) {
            navigationController.popToViewController(viewController, animated: true)
        } else {
            if let backstackController {
                var vcs = navigationController.viewControllers
                vcs.removeAll(where: { $0 === backstackController })
                navigationController.setViewControllers(vcs, animated: false)
            }
            heroic.replace(self, with: viewController)
        }
    }

    func popover(_ viewController: UIViewController, withMediumDetent: Bool = false) {
        viewController.applyPrefferedSheetPresentationStyle(withMediumDetent)
        present(viewController, animated: true)
    }

    func present(_ viewController: UIViewController) { // , attachedTo sender: ContentBase? = nil) {
        if let bctrl = viewController as? BulletinController {
            bctrl.presenter = self
            if let bulletin = bctrl.bulletin {
                showBulletin(bulletin)
            }
            return
        }

        @Injected var heroic: Heroic
        heroic.finish(animate: false)

        whenPushback()

        heroic.copyAnimation(from: viewController, to: navigationController)

//        if viewController is UIImagePickerController {
//            viewController.modalPresentationStyle = .popover
//        }
//
//        if let popover = viewController.popoverPresentationController {
//            popover.sourceView = sender?.container ?? view
//            popover.canOverlapSourceViewRect = true
//            popover.permittedArrowDirections = .any
//        }

        view.layer.pauseAnimations()
        let child = childViewController
        child?.view.layer.pauseAnimations()

        delay(.halfOfSecond) { [self] in
            view.layer.resumeAnimations()
            child?.view.layer.resumeAnimations()
        }

        trace(i: "#", viewController)

        if #available(iOS 14, *) {
            if let navigationController,
               !(viewController is UINavigationController),
               !(viewController is PHPickerViewController) {
                navigationController.pushViewController(viewController, animated: true)
                return
            }
        } else {
            if let navigationController,
               !(viewController is UINavigationController) {
                navigationController.pushViewController(viewController, animated: true)
                return
            }
        }

        (tabBarController ?? self).present(viewController, animated: true)
    }

    func dismiss() {
        @Injected var heroic: Heroic
        heroic.finish(animate: false)

        if !isDeparting { whenDismiss(interactive: false) }

        heroic.copyAnimation(from: self, to: navigationController)

        guard let navigationController else {
            dismiss(animated: true) { [weak self] in
                self?.whenDettached()
            }
            return
        }

        var backstackCandidate: UIViewController? = backstackController
        // TODO: Do we really need to find the root of backstack?
        while let superBackstack = backstackCandidate?.backstackController {
            backstackCandidate = superBackstack
        }

        if let backstackCandidate {
            backstackCandidate.whenPopback()

            var vcs = navigationController.viewControllers
            if !vcs.isEmpty, !vcs.contains(backstackCandidate) {
                let last = vcs.removeLast()
                vcs.append(backstackCandidate)
                vcs.append(last)
                navigationController.setViewControllers(vcs, animated: false)
            }

            if navigationController.viewControllers.contains(backstackCandidate) {
                navigationController.popToViewController(backstackCandidate, animated: true) { [weak self] in
                    self?.checkDismissInNavigationController()
                }
            } else {
                navigationController.popToRootViewController(animated: true) { [weak self] in
                    self?.checkDismissInNavigationController()
                }
            }

            return
        }

        if navigationController.viewControllers.last == self {
            navigationController.popViewController(animated: true) { [weak self] in
                self?.checkDismissInNavigationController()
            }
            return
        }

        navigationController.popToRootViewController(animated: true) { [weak self] in
            self?.checkDismissInNavigationController()
        }
    }
}

private extension UIViewController {
    func checkDismissInNavigationController() {
        if navigationController?.viewControllers.last == self {
            whenCancelDismiss()
        } else {
            whenDettached()
        }
    }

    func applyPrefferedSheetPresentationStyle(_ withMediumDetent: Bool = false) {
        if #available(iOS 16.0, *), !UIViewController.isStackingAllowed {
            modalTransitionStyle = .coverVertical
            modalPresentationStyle = .pageSheet
            let nonStack = UISheetPresentationController.Detent.Identifier("nonStackDetent")
            let nonStackDetent = UISheetPresentationController.Detent.custom(identifier: nonStack) { context in
                context.maximumDetentValue - 1 // this will make the view controllers not stack up
            }
            sheetPresentationController?.detents = withMediumDetent ? [.medium(), nonStackDetent] : [nonStackDetent]
        } else {
            modalPresentationStyle = .pageSheet
            modalTransitionStyle = .coverVertical
        }
    }
}

private extension UINavigationController {
    func completionHelper(for completion: (() -> Void)?) {
        if let transitionCoordinator = transitionCoordinator {
            transitionCoordinator.animate(alongsideTransition: nil) { _ in
                completion?()
            }
        } else {
            delay(.thirdOfSecond) {
                completion?()
            }
        }
    }

    func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        pushViewController(viewController, animated: animated)
        completionHelper(for: completion)
    }

    func popViewController(animated: Bool, completion: (() -> Void)?) {
        popViewController(animated: animated)
        completionHelper(for: completion)
    }

    func popToRootViewController(animated: Bool, completion: (() -> Void)?) {
        popToRootViewController(animated: animated)
        completionHelper(for: completion)
    }

    func popToViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        popToViewController(viewController, animated: animated)
        completionHelper(for: completion)
    }
}
