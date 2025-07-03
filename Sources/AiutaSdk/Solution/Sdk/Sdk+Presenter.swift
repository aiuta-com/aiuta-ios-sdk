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
extension Sdk {
    @MainActor enum Presenter {
        public static var isForeground: Bool = false

        public static func tryOn(product: Aiuta.Product, in viewController: UIViewController) async {
            guard Register.ensureConfigured() else { return }
            @injected var session: Sdk.Core.Session
            session.start(with: product)
            @injected var tryOn: Sdk.Core.TryOn
            tryOn.sessionResults.removeAll()
            @injected var tracker: AnalyticTracker
            tracker.track(.session(flow: .tryOn, productIds: session.products.ids))
            viewController.present(Navigator(rootViewController: await entryViewController()), animated: true)
        }

        public static func showHistory(in viewController: UIViewController) async -> Bool {
            guard Register.ensureConfigured() else { return false }
            @injected var configuration: Sdk.Configuration
            guard configuration.features.tryOn.hasGenerationsHistory else { return false }
            @injected var session: Sdk.Core.Session
            session.start()
            @injected var tracker: AnalyticTracker
            tracker.track(.session(flow: .history, productIds: []))
            viewController.present(Navigator(rootViewController: HistoryViewController()), animated: true)
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
