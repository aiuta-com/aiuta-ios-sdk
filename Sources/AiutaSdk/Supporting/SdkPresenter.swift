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
    public static func tryOn(sku: Aiuta.SkuInfo,
                             withMoreToTryOn relatedSkus: [Aiuta.SkuInfo] = [],
                             in viewController: UIViewController,
                             delegate: AiutaSdkDelegate) {
        guard SdkRegister.insureConfigured() else { return }
        let session = Aiuta.TryOnSession(tryOnSku: sku, moreToTryOn: relatedSkus, delegate: delegate)
        let tryOnVc = AiutaTryOnViewController(session: session)
        let startVc = tryOnVc.hasUploads ? tryOnVc : AiutaOnboardingViewController(forward: tryOnVc)
        viewController.present(startVc, animated: true)
    }

    public static func showHistory(in viewController: UIViewController) -> Bool {
        guard SdkRegister.insureConfigured() else { return false }
        @injected var configuration: Aiuta.Configuration
        guard configuration.behavior.isHistoryAvailable else { return false }
        viewController.present(AiutaGenerationsHistoryViewController(), animated: true)
        return true
    }
}
