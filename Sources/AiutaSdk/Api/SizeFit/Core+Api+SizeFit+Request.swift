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
import Alamofire

extension Aiuta.SizeRecommendation {
    struct ByChart: Encodable, ApiRequest {
        var urlPath: String { "size_and_fit/recommendation" }
        var method: HTTPMethod { .post }

        let code: String
        let age: Int
        let height: Int
        let weight: Int
        let gender: Aiuta.FitSurvey.Gender

        let hipShape: Aiuta.FitSurvey.HipShape?
        let bellyShape: Aiuta.FitSurvey.BellyShape?
        let braSize: Int?
        let braCup: Aiuta.FitSurvey.BraCup?

        var retryCount: Int {
            @injected var subscription: Sdk.Core.Subscription
            return subscription.retryCounts.operationStart
        }
    }
}
