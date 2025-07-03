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
import Alamofire

@available(iOS 13.0.0, *)
extension Sdk.Core.Api {
    @_spi(Aiuta) public struct Provider: ApiProvider {
        public let baseUrl: String
        public let keyCodingStrategy: ApiCodingStrategy
        private let auth: Aiuta.Auth

        public init(auth: Aiuta.Auth,
                    baseUrl: String = "https://api.aiuta.com/digital-try-on/v1",
                    keyCodingStrategy: ApiCodingStrategy = .convertSnakeCase) {
            self.auth = auth
            self.baseUrl = baseUrl
            self.keyCodingStrategy = keyCodingStrategy
        }

        public func authorize(headers: inout HTTPHeaders, for request: ApiRequest) async throws {
            switch auth {
                case let .apiKey(apiKey):
                    headers.add(.authorization(xApiKey: apiKey))
                case let .jwt(subscriptionId, jwtProvider):
                    if request.isSecure {
                        let params: [String: String] = request.secureAuthFields ?? [:]
                        let token = try await jwtProvider.getJwt(requestParams: params)
                        headers.add(.authorization(bearerToken: token))
                    } else {
                        headers.add(.authorization(xUserId: subscriptionId))
                    }
            }
        }
    }
}
