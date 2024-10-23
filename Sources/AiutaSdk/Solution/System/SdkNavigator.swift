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

    private let presentingAlphaChangeDuration = 0.4
    private var presentingOriginalAlpha: CGFloat = 1
    private let presentingTargetAlpha: CGFloat = 0.6
    private var presentingDimmedAlpha: CGFloat = 0.6
    private var presentingOriginalTint: UIColor?

    private let touchesDismissAreaHeight: CGFloat = 52
    private var touchesBeganInsideDismissArea: Bool?

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
        presentingOriginalAlpha = presentingViewController?.view.alpha ?? presentingOriginalAlpha
        presentingOriginalTint = presentingViewController?.view.window?.tintColor
        presentingViewController?.view.window?.tintColor = ds.color.accent
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard config.appearance.presentationStyle == .bottomSheet else { return }
        UIView.animate(withDuration: presentingAlphaChangeDuration) { [self] in
            presentingViewController?.view.alpha = presentingDimmedAlpha
        }
    }

    func sdkWillDismiss() {
        presentingDimmedAlpha = presentingTargetAlpha
        guard config.appearance.presentationStyle == .bottomSheet else { return }
        UIView.animate(withDuration: presentingAlphaChangeDuration) { [self] in
            presentingViewController?.view.alpha = presentingOriginalAlpha
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presentingDimmedAlpha = presentingViewController?.view.alpha ?? presentingDimmedAlpha
    }

    func sdkDidDismiss() {
        trace("SDK DID DISMISS")
        trace("===============")
        if let presentingOriginalTint {
            presentingViewController?.view.window?.tintColor = presentingOriginalTint
        }
        if let page = (visibleViewController as? PageRepresentable)?.page {
            @injected var session: SessionModel
            session.delegate?.aiuta(eventOccurred: .exit(pageId: page))
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
        if visibleViewController?.hasBulletin == true { return false }
        if let touchesBeganInsideDismissArea { return touchesBeganInsideDismissArea }
        if let page = visibleViewController as? PageRepresentable { return page.isSafeToDismiss }
        return true
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
