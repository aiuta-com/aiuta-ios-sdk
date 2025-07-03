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

@_spi(Aiuta) extension UIViewController {
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

    public var statusBarStyle: UIStatusBarStyle {
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
            animate(time: .thirdOfSecond) { [self] in setNeedsStatusBarAppearanceUpdate() }
        }
    }

    public internal(set) var isAttached: Bool {
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
        }
    }

    var isDeparting: Bool {
        get { getAssociatedProperty(&Property.isDeparting, defaultValue: Property.isDeparting) }
        set { setAssociatedProperty(&Property.isDeparting, newValue: newValue) }
    }

    public internal(set) var backstackController: UIViewController? {
        get { getAssociatedProperty(&Property.backstackController, ofType: UIViewController.self) }
        set { setAssociatedProperty(&Property.backstackController, newValue: newValue) }
    }

    public func dropBackstack() { backstackController = nil }

    var willTransitInteractive: Bool {
        get { getAssociatedProperty(&Property.willTransitInteractive, defaultValue: Property.willTransitInteractive) }
        set { setAssociatedProperty(&Property.willTransitInteractive, newValue: newValue) }
    }

    var hasTransitionUpdates: Bool {
        get { getAssociatedProperty(&Property.hasTransitionUpdates, defaultValue: Property.hasTransitionUpdates) }
        set { setAssociatedProperty(&Property.hasTransitionUpdates, newValue: newValue) }
    }

    public var childViewController: UIViewController? {
        (self as? UITabBarController)?.selectedViewController
    }

    public var viewAsUI: ContentBase? {
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
    
    public var hasBulletin: Bool {
        bulletinManager.currentBulletin.isSome
    }
}
