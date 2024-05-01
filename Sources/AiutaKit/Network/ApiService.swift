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

import Alamofire
import Foundation

@available(iOS 13.0.0, *)
@_spi(Aiuta) public protocol ApiService {
    func request<Request: Encodable & ApiRequest, Response: Decodable>(_ request: Request) async throws -> (Response, HTTPHeaders?)
}

@available(iOS 13.0.0, *)
@_spi(Aiuta) public extension ApiService {
    func request<Request: Encodable & ApiRequest, Response: Decodable>(_ request: Request) async throws -> Response {
        try await self.request(request).0
    }
}
