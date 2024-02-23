//
//  Created by nGrey on 05.07.2023.
//


import PhotosUI
import UIKit

extension UIViewController {
    func replace(with viewController: UIViewController, backstack: UIViewController? = nil) {
        if let bctrl = viewController as? BulletinController, let bulletin = bctrl.bulletin {
            bctrl.presenter = self
            showBulletin(bulletin)
            return
        }

        Hero.shared.finish(animate: false)

        whenPushback()

        navigationController?.hero.navigationAnimationType = viewController.hero.modalAnimationType
        viewController.backstackController = backstack

        guard let navigationController else {
            hero.replaceViewController(with: viewController)
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
            hero.replaceViewController(with: viewController)
        }
    }

    func present(_ viewController: UIViewController, attachedTo sender: ContentBase? = nil) {
        if let bctrl = viewController as? BulletinController, let bulletin = bctrl.bulletin {
            bctrl.presenter = self
            showBulletin(bulletin)
            return
        }

        Hero.shared.finish(animate: false)

        whenPushback()

        navigationController?.hero.navigationAnimationType = viewController.hero.modalAnimationType

        if viewController is UIImagePickerController {
            viewController.modalPresentationStyle = .popover
        }

        if let popover = viewController.popoverPresentationController {
            popover.sourceView = sender?.container ?? view
            popover.canOverlapSourceViewRect = true
            popover.permittedArrowDirections = .any
        }

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
        Hero.shared.finish(animate: false)

        if !isDeparting {
            whenDismiss(interactive: false)
            delay(.thirdOfSecond) { [weak self] in self?.whenDettached() }
        }

        navigationController?.hero.navigationAnimationType = hero.modalAnimationType

        guard let navigationController else {
            dismiss(animated: true)
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
                navigationController.popToViewController(backstackCandidate, animated: true)
            } else {
                navigationController.popToRootViewController(animated: true)
            }

            return
        }

        if navigationController.viewControllers.last == self {
            navigationController.popViewController(animated: true)
            return
        }

        navigationController.popToRootViewController(animated: true)
    }
}
