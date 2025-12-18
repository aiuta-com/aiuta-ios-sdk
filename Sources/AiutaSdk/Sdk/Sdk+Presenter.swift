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
import AiutaCore
import UIKit

@available(iOS 13.0.0, *)
extension Sdk {
    @MainActor enum Presenter {
        public static var isForeground: Bool = false

        public static func tryOn(products: Aiuta.Products) async {
            guard let currentViewController else { return }
            guard Register.ensureConfigured() else { return }
            @injected var session: Sdk.Core.Session
            session.start(with: products)
            @injected var tryOn: Sdk.Core.TryOn
            tryOn.sessionResults.removeAll()
            @injected var tracker: AnalyticTracker
            tracker.track(.session(flow: .tryOn, productIds: session.products.ids))
            currentViewController.present(Navigator(rootViewController: await entryViewController()), animated: true)
        }
        
        public static func sizeFit(product: Aiuta.Product) async {
            guard let currentViewController else { return }
            guard Register.ensureConfigured() else { return }
            @injected var session: Sdk.Core.Session
            session.start(with: [product])
            @injected var tracker: AnalyticTracker
            tracker.track(.session(flow: .sizeFit, productIds: session.products.ids))
            currentViewController.present(Navigator(rootViewController: FitSurveyVC()), animated: true)
        }

        public static func showHistory() async -> Bool {
            guard let currentViewController else { return false }
            guard Register.ensureConfigured() else { return false }
            @injected var configuration: Sdk.Configuration
            guard configuration.features.tryOn.hasGenerationsHistory else { return false }
            @injected var session: Sdk.Core.Session
            session.start()
            @injected var tracker: AnalyticTracker
            tracker.track(.session(flow: .history, productIds: []))
            currentViewController.present(Navigator(rootViewController: HistoryVC()), animated: true)
            return true
        }
    }
}

@available(iOS 13.0.0, *)
extension Sdk.Presenter {
    static func entryViewController() async -> UIViewController {
        @injected var onboarding: Sdk.Core.Onboarding
        if await onboarding.needsWelcome {
            return Sdk.Features.WelcomeScreen()
        }

        if await onboarding.needsOnboarding {
            return Sdk.Features.Onboarding()
        }

        @injected var consent: Sdk.Core.Consent
        if await consent.isRequiredOnBoarding {
            return Sdk.Features.Consent()
        }

        return Sdk.Features.TryOn()
    }
}

@available(iOS 13.0, *)
extension Sdk.Presenter {
    static func takeScreenshot() {
        guard let view = currentViewController?.view else { return }
        let bounds = view.bounds
        let size = CGSize(width: bounds.size.width,
                          height: bounds.size.height - view.safeAreaInsets.bottom + 8)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        view.drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image else { return }
        currentViewController?.share(image: image)
    }

    static var currentViewController: UIViewController? {
        if #available(iOS 13.0, *) {
            // For iOS 13+, find the first active window scene
            let windowScene = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first { $0.activationState == .foregroundActive }
            
            let keyWindow = windowScene?.windows.first { $0.isKeyWindow }
            return topViewController(keyWindow?.rootViewController)
        } else {
            // For iOS 12 and below, use the legacy approach
            return topViewController(UIApplication.shared.keyWindow?.rootViewController)
        }
    }

    private static func topViewController(_ base: UIViewController?) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return topViewController(tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
