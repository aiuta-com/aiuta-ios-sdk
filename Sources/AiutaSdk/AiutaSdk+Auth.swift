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

import Foundation

@available(iOS 13.0.0, *)
extension Aiuta {
    public enum AuthType {
        ///   - apiKey: The API key provided by Aiuta for accessing its services.
        ///             See [Getting Started](https://developer.aiuta.com/docs/start) for instructions to obtain your API KEY.
        ///             See [Digital Try On](https://developer.aiuta.com/products/digital-try-on/Documentation) Api Reference.
        case apiKey(apiKey: String)

        ///   - subscriptionId: You can find the subscription ID in the URL of a subscription you have.
        ///             See [Getting Started](https://developer.aiuta.com/docs/start) how to use JWT auth.
        case jwt(subscriptionId: String, jwtProvider: AiutaJwtProvider)
    }
}

@available(iOS 13.0.0, *)
public protocol AiutaJwtProvider {
    /// See [Using JWT](https://developer.aiuta.com/docs/start#using-jwt)
    func getJwt(requestParams: [String: String]) async throws -> String
}
