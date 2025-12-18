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
import Kingfisher
import UIKit

@available(iOS 13.0.0, *)
extension Sdk.Core {
    final class SizeFitImpl: SizeFit {
        let onChange = Signal<Void>()

        private let api: ApiService?
        private let config: Sdk.Configuration
        @injected private var session: Sdk.Core.Session

        @defaults(key: "fitSurvey", defaultValue: nil)
        var lastSurvey: Aiuta.FitSurvey?

        var isAvailable: Bool {
            guard let product = session.products.first else { return false }
            guard let feature = config.features.sizeFit else { return false }
            return feature.sizeChartMap.keys.contains(product.id)
        }

        init() {
            @injected var config: Sdk.Configuration
            self.config = config
            if let apiKey = config.features.sizeFit?.apiKey {
                api = RestService(Api.Provider(auth: .apiKey(apiKey), baseUrl: Sdk.Core.Api.sizeFit),
                                  debugger: Api.Debugger(isEnabled: true))
            } else {
                api = nil
            }
        }

        func recommendation(survey: Aiuta.FitSurvey, product: Aiuta.Product) async throws -> Aiuta.SizeRecommendation {
            let hasChanges = lastSurvey != survey
            lastSurvey = survey

            guard let api, let code = config.features.sizeFit?.sizeChartMap[product.id] else {
                throw SizeFitError.abort
            }

            let result: Aiuta.SizeRecommendation = try await api.request(Aiuta.SizeRecommendation.ByChart(
                code: code,
                age: survey.age,
                height: survey.height,
                weight: survey.weight,
                gender: survey.gender
            ))

            if hasChanges {
                onChange.fire()
            }

            return result
        }
    }
}

extension Aiuta.FitSurvey {
    var description: String {
        "\(gender.rawValue) / \(age) years / \(height) cm / \(weight) kg"
    }
}
