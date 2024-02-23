//
//  Created by nGrey on 05.07.2023.
//

import UIKit

extension UIViewController {
    private struct Property {
        static var isAttached: Bool = false
        static var isAppearing: Bool = false
        static var isDeparting: Bool = false

        static var willTransitInteractive: Bool = false
        static var hasTransitionUpdates: Bool = false
        static var statusBarStyle: Void?

        static var bulletinManager: Void?
        static var backstackController: Void?
        static var componentControllers: Void?
    }

    var statusBarStyle: UIStatusBarStyle {
        get {
            if #available(iOS 13.0, *) {
                getAssociatedProperty(&Property.statusBarStyle, defaultValue: .darkContent)
            } else {
                getAssociatedProperty(&Property.statusBarStyle, defaultValue: .default)
            }
        }
        set {
            guard newValue != statusBarStyle else { return }
            setAssociatedProperty(&Property.statusBarStyle, newValue: newValue)
            animate { [self] in setNeedsStatusBarAppearanceUpdate() }
        }
    }

    var isAttached: Bool {
        get { getAssociatedProperty(&Property.isAttached, defaultValue: Property.isAttached) }
        set {
            guard newValue != isAttached else { return }
            setAssociatedProperty(&Property.isAttached, newValue: newValue)
            if newValue { whenAttached() }
        }
    }

    var isAppearing: Bool {
        get { getAssociatedProperty(&Property.isAppearing, defaultValue: Property.isAppearing) }
        set {
            guard newValue != isAppearing else { return }
            setAssociatedProperty(&Property.isAppearing, newValue: newValue)
            if newValue { whenDidAppear() } else { whenDidDisappear() }
            if newValue { trace(i: "#", self) }
        }
    }

    var isDeparting: Bool {
        get { getAssociatedProperty(&Property.isDeparting, defaultValue: Property.isDeparting) }
        set { setAssociatedProperty(&Property.isDeparting, newValue: newValue) }
    }

    var backstackController: UIViewController? {
        get { getAssociatedProperty(&Property.backstackController, ofType: UIViewController.self) }
        set { setAssociatedProperty(&Property.backstackController, newValue: newValue) }
    }

    var willTransitInteractive: Bool {
        get { getAssociatedProperty(&Property.willTransitInteractive, defaultValue: Property.willTransitInteractive) }
        set { setAssociatedProperty(&Property.willTransitInteractive, newValue: newValue) }
    }

    var hasTransitionUpdates: Bool {
        get { getAssociatedProperty(&Property.hasTransitionUpdates, defaultValue: Property.hasTransitionUpdates) }
        set { setAssociatedProperty(&Property.hasTransitionUpdates, newValue: newValue) }
    }

    var childViewController: UIViewController? {
        (self as? UITabBarController)?.selectedViewController
    }

    var viewAsUI: ContentBase? {
        (view as? ContentView)?.content ?? (view.subviews.last as? ContentView)?.content
    }

    var componentControllers: [ComponentControllerBase]? {
        get { getAssociatedProperty(&Property.componentControllers, ofType: [ComponentControllerBase].self) }
        set { setAssociatedProperty(&Property.componentControllers, newValue: newValue) }
    }

    var bulletinManager: BulletinManager {
        if let pager = parent as? UIPageViewController { return pager.bulletinManager }

        var bulletinManager = getAssociatedProperty(&Property.bulletinManager, ofType: BulletinManager.self)
        if bulletinManager.isNil {
            bulletinManager = BulletinManager(viewController: self)
            setAssociatedProperty(&Property.bulletinManager, newValue: bulletinManager)
        }
        return bulletinManager!
    }
}
