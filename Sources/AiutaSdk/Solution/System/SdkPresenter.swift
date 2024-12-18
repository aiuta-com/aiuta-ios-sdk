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
    public static var isForeground: Bool = false
    
    public static func tryOn(sku: Aiuta.Product,
                             in viewController: UIViewController,
                             delegate: AiutaSdkDelegate) {
        guard SdkRegister.ensureConfigured() else { return }
        @injected var sessionModel: SessionModel
        sessionModel.start(sku: sku, delegate: delegate)
        @injected var tryOnModel: TryOnModel
        tryOnModel.sessionResults.removeAll()
        @injected var tracker: AnalyticTracker
        tracker.track(.session(flow: .tryOn, product: sku))
        viewController.present(SdkNavigator(rootViewController: entryViewController()), animated: true)
    }

    public static func showHistory(in viewController: UIViewController,
                                   delegate: AiutaSdkDelegate) -> Bool {
        guard SdkRegister.ensureConfigured() else { return false }
        @injected var sessionModel: SessionModel
        sessionModel.delegate = delegate
        @injected var configuration: Aiuta.Configuration
        guard configuration.behavior.isTryonHistoryAvailable else { return false }
        @injected var tracker: AnalyticTracker
        tracker.track(.session(flow: .history, product: nil))
        viewController.present(SdkNavigator(rootViewController: HistoryViewController()), animated: true)
        return true
    }
}

@available(iOS 13.0.0, *)
extension SdkPresenter {
    static func entryViewController() -> UIViewController {
        @injected var consentModel: ConsentModel
        if consentModel.isConsentGiven {
            return TryOnViewController()
        }

        @injected var configuration: Aiuta.Configuration
        if configuration.behavior.showSplashScreenBeforeOnboadring {
            return SplashViewController()
        }

        return OnBoardingViewController()
    }
}
