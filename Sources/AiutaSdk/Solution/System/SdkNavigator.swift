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
import UIKit

final class SdkNavigator: UINavigationController {
    private var originalPresenterWindow: UIWindow?
    private var originalInterfaceStyle: UIUserInterfaceStyle?
    private var presentingOriginalAlpha: CGFloat = 1
    private let presentingTargetAlpha: CGFloat = 0.6
    private var presentingDimmedAlpha: CGFloat = 0.6
    private let presentingAlphaChangeDuration = 0.4
    @injected var config: Aiuta.Configuration

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
        if #available(iOS 16.0, *), config.appearance.presentationStyle == .bottomSheet {
            let nonStack = UISheetPresentationController.Detent.Identifier("nonStackDetent")
            sheetPresentationController?.detents = [.custom(identifier: nonStack) { context in
                context.maximumDetentValue - 1 // this will make the view controllers not stack up
            }]
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sdkWillReappear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sdkDidAppear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sdkDidDisappear()
    }

    func sdkWillAppear() {
        trace("---------------")
        trace("SDK WILL APPEAR")
        originalPresenterWindow = presentingViewController?.view.window
        presentingOriginalAlpha = presentingViewController?.view.alpha ?? presentingOriginalAlpha
        if #available(iOS 13.0, *) {
            originalInterfaceStyle = presentingViewController?.view.window?.overrideUserInterfaceStyle
        }
    }

    func sdkWillReappear() {
        guard config.appearance.presentationStyle == .bottomSheet else { return }
        UIView.animate(withDuration: presentingAlphaChangeDuration) { [self] in
            presentingViewController?.view.alpha = presentingDimmedAlpha
        }
    }

    func sdkDidAppear() {
        if #available(iOS 13.0, *), let window = presentingViewController?.view.window {
            delay(.moment) { [self] in
                UIView.transition(with: window, duration: presentingAlphaChangeDuration / 2, options: [.transitionCrossDissolve, .allowUserInteraction]) { [self] in
                    presentingViewController?.view.window?.overrideUserInterfaceStyle = config.appearance.colors.style.userInterface
                }
            }
        }
    }

    func sdkDidDisappear() {
        presentingDimmedAlpha = presentingViewController?.view.alpha ?? presentingDimmedAlpha
    }

    func sdkWillDismiss() {
        presentingDimmedAlpha = presentingTargetAlpha
        UIView.animate(withDuration: presentingAlphaChangeDuration) { [self] in
            presentingViewController?.view.alpha = presentingOriginalAlpha
        }
    }

    func sdkDidDismiss() {
        trace("SDK DID DISMISS")
        trace("===============")
        if #available(iOS 13.0, *), let originalInterfaceStyle, let originalPresenterWindow {
            UIView.transition(with: originalPresenterWindow, duration: presentingAlphaChangeDuration / 2, options: [.transitionCrossDissolve, .allowUserInteraction]) {
                originalPresenterWindow.overrideUserInterfaceStyle = originalInterfaceStyle
            }
        }
        if let page = (visibleViewController as? PageRepresentable)?.page {
            @injected var session: SessionModel
            session.delegate?.aiuta(eventOccurred: .exit(pageId: page))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SdkNavigator: UIAdaptivePresentationControllerDelegate {
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        if visibleViewController?.hasBulletin == true { return false }
        return true
    }

    func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        sdkWillAppear()
    }

    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        sdkWillDismiss()
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        sdkDidDismiss()
    }
}
