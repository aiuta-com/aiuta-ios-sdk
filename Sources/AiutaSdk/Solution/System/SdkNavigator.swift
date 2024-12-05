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

@_spi(Aiuta) import AiutaKit
import Resolver
import UIKit

@available(iOS 13.0, *)
final class SdkNavigator: UINavigationController {
    @injected private var config: Aiuta.Configuration
    @Injected private var ds: DesignSystem

    private let touchesDismissAreaHeight: CGFloat = 52
    private var touchesBeganInsideDismissArea: Bool?
    private var bulletinWall: BulletinWall?

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setNavigationBarHidden(true, animated: false)
        applyPreferedAppearancePresentationStyle()
        presentationController?.delegate = self
    }

    func applyPreferedAppearancePresentationStyle() {
        modalTransitionStyle = .coverVertical
        modalPresentationStyle = config.appearance.presentationStyle.modalPresentationStyle
        UIViewController.isStackingAllowed = config.appearance.presentationStyle.allowViewControllersStackUp
        if config.appearance.presentationStyle == .bottomSheet { applyNonStackDetendsIfNeeded(withMediumDetent: false) }
    }

    func sdkWillAppear() {
        trace("---------------")
        trace("SDK WILL APPEAR")
        bulletinWall = BulletinWall(injectingTo: presentingViewController?.view)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bulletinWall?.increase(max: 1)
    }

    func sdkWillDismiss() {
        bulletinWall?.reduce(to: 0)
    }

    func sdkDidDismiss() {
        trace("SDK DID DISMISS")
        trace("===============")
        bulletinWall?.dismiss()
        if let page = (visibleViewController as? PageRepresentable)?.page {
            @injected var session: SessionModel
            session.track(.exit(page: page, product: session.activeSku))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchY = touches.first?.location(in: view).y {
            touchesBeganInsideDismissArea = touchY <= touchesDismissAreaHeight
        } else {
            touchesBeganInsideDismissArea = nil
        }
        super.touchesBegan(touches, with: event)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesBeganInsideDismissArea = nil
        super.touchesEnded(touches, with: event)
    }
}

@available(iOS 13.0, *)
extension SdkNavigator: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        defer { touchesBeganInsideDismissArea = nil }
        if visibleViewController?.hasBulletin == true { return false }
        switch config.appearance.swipeToDismissPolicy {
            case .allowAlways: return true
            case .protectTheNecessary:
                guard let page = visibleViewController as? PageRepresentable else { return true }
                if page.isSafeToDismiss { return true }
                if let touchesBeganInsideDismissArea { return touchesBeganInsideDismissArea }
            case .allowHeaderSwipeOnly:
                if let touchesBeganInsideDismissArea { return touchesBeganInsideDismissArea }
        }
        return false
    }

    func presentationController(_ presentationController: UIPresentationController,
                                willPresentWithAdaptiveStyle style: UIModalPresentationStyle,
                                transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        sdkWillAppear()
    }

    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        sdkWillDismiss()
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        sdkDidDismiss()
    }
}
