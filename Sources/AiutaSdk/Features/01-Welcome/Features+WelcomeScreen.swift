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

import AiutaCore
@_spi(Aiuta) import AiutaKit
import UIKit

extension Sdk.Features {
    @available(iOS 13.0.0, *)
    final class WelcomeScreen: ViewController<Sdk.UI.WelcomeScreen> {
        @injected private var session: Sdk.Core.Session
        @injected private var tracker: AnalyticTracker

        override func setup() {
            ui.closeButton.onTouchUpInside.subscribe(with: self) { [unowned self] in
                dismissAll()
            }

            ui.startButton.onTouchUpInside.task(with: self) { [unowned self] in
                tracker.track(.onboarding(event: .welcomeStartClicked, pageId: page, productIds: session.products.ids))
                
                @injected var onboarding: Sdk.Core.Onboarding
                if await onboarding.needsOnboarding {
                    replace(with: Onboarding(), backstack: self)
                    return
                }

                @injected var consent: Sdk.Core.Consent
                if await consent.isRequiredOnBoarding {
                    replace(with: Consent(), backstack: self)
                    return
                }

                replace(with: TryOn())
            }

            tracker.track(.page(pageId: page, productIds: session.products.ids))
        }

        override func whenPopback() {
            tracker.track(.page(pageId: page, productIds: session.products.ids))
        }
    }
}

@available(iOS 13.0.0, *)
extension Sdk.Features.WelcomeScreen: PageRepresentable {
    var page: Aiuta.Event.Page { .welcome }
    var isSafeToDismiss: Bool { true }
}
