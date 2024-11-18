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

@available(iOS 13.0.0, *)
final class DataProviderImpl: AiutaDataProvider {
    @injected private var sessionModel: SessionModel
    @injected private var consentModel: ConsentModel
    @injected private var historyModel: HistoryModel

    init(controller: AiutaDataController) {
        sessionModel.controller = controller
    }

    var isUserConsentObtained: Bool {
        get { consentModel.isConsentGiven }
        set { consentModel.isConsentGiven = newValue }
    }

    var uploadedImages: [Aiuta.Image] {
        get { historyModel.uploaded.items }
        set { historyModel.setUploaded(newValue) }
    }

    var generatedImages: [Aiuta.Image] {
        get { historyModel.generated.items }
        set { historyModel.setGenerated(newValue) }
    }

    func setProduct(_ product: Aiuta.Product, isInWishlist: Bool) {
        if sessionModel.isInWishlist(product) != isInWishlist {
            sessionModel.toggleWishlist(product)
        }
    }
}
