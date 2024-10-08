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

@_spi(Aiuta) public struct SdkApiProvider: ApiProvider {
    public let baseUrl: String
    let apiKey: String

    public func authorize(headers: inout HTTPHeaders) async throws {
        headers.add(.authorization(xApiKey: apiKey))
    }

    public init(apiKey: String, baseUrl: String = "https://api.aiuta.com/digital-try-on/v1") {
        self.baseUrl = baseUrl
        self.apiKey = apiKey
    }
}
