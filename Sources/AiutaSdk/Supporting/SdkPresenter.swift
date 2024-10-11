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

@available(iOS 13.0.0, *)
enum SdkPresenter {
    public static func tryOn(sku: Aiuta.Product,
                             withMoreToTryOn relatedSkus: [Aiuta.Product] = [],
                             in viewController: UIViewController,
                             delegate: AiutaSdkDelegate) {
        guard SdkRegister.ensureConfigured() else { return }
        @injected var sessionModel: SessionModel
        sessionModel.start(sku: sku, delegate: delegate)
        @injected var consentModel: ConsentModel
        let startVc = consentModel.isConsentGiven ? TryOnViewController() : OnBoardingViewController()
        viewController.present(SdkNavigator(rootViewController: startVc), animated: true)
    }

    public static func showHistory(in viewController: UIViewController) -> Bool {
        guard SdkRegister.ensureConfigured() else { return false }
        @injected var configuration: Aiuta.Configuration
        guard configuration.behavior.isHistoryAvailable else { return false }
        viewController.present(SdkNavigator(rootViewController: HistoryViewController()), animated: true)
        return true
    }
}

// MARK: - Navigator

private final class SdkNavigator: UINavigationController {
    private var presentingOriginalAlpha: CGFloat = 1
    private let presentingTargetAlpha: CGFloat = 0.6
    private var presentingDimmedAlpha: CGFloat = 0.6
    private let presentingAlphaChangeDuration = 0.4
    @injected var config: Aiuta.Configuration

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setNavigationBarHidden(true, animated: false)
        applyPrefferedPresentationStyle()
        presentationController?.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sdkWillReappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sdkDidDisappear()
    }

    func sdkWillAppear() {
        trace("---------------")
        trace("SDK WILL APPEAR")
        presentingOriginalAlpha = presentingViewController?.view.alpha ?? presentingOriginalAlpha
    }

    func sdkWillReappear() {
        guard config.appearance.presentationStyle == .bottomSheet else { return }
        UIView.animate(withDuration: presentingAlphaChangeDuration) { [self] in
            presentingViewController?.view.alpha = presentingDimmedAlpha
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

// MARK: - Presentation extension

extension UIViewController {
    func applyPrefferedPresentationStyle() {
        @injected var config: Aiuta.Configuration
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

    func popoverOrCover(_ vc: UIViewController) {
        @injected var config: Aiuta.Configuration
        if config.appearance.presentationStyle.isFullScreen {
            cover(vc)
        } else {
            (navigationController ?? self).popover(vc)
        }
    }

    func cover(_ vc: UIViewController) {
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        (navigationController ?? self).present(vc, animated: true)
    }

    func dismissAll(completion: (() -> Void)? = nil) {
        if let navigator = navigationController as? SdkNavigator {
            navigator.sdkWillDismiss()
            navigator.dismiss(animated: true) {
                navigator.sdkDidDismiss()
                completion?()
            }
        } else {
            dismiss(animated: true, completion: completion)
        }
    }
}

// MARK: - Presentation style

extension Aiuta.Configuration.PresentationStyle {
    var modalPresentationStyle: UIModalPresentationStyle {
        switch self {
            case .pageSheet, .bottomSheet: return .pageSheet
            case .fullScreen: return .fullScreen
        }
    }

    var shoudInsetContentFromTop: Bool {
        isFullScreen
    }

    var allowViewControllersStackUp: Bool {
        switch self {
            case .pageSheet, .fullScreen: return true
            case .bottomSheet: return false
        }
    }

    var isFullScreen: Bool {
        switch self {
            case .pageSheet, .bottomSheet: return false
            case .fullScreen: return true
        }
    }
}
