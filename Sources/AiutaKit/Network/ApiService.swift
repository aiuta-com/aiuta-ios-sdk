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

@_spi(Aiuta) public protocol ApiService {
    func request<Request: ApiRequest & Encodable, Response: Decodable>(_ request: Request, debugger: ApiDebuggerOperation?, breadcrumbs: Breadcrumbs?) async throws -> ApiResponse<Response>
}

@_spi(Aiuta) public extension ApiService {
    func request<Request: ApiRequest & Encodable, Response: Decodable>(_ request: Request, debugger: ApiDebuggerOperation?, breadcrumbs: Breadcrumbs?) async throws -> Response {
        try await self.request(request, debugger: debugger, breadcrumbs: breadcrumbs).response
    }

    func request<Request: ApiRequest & Encodable, Response: Decodable>(_ request: Request, breadcrumbs: Breadcrumbs?) async throws -> ApiResponse<Response> {
        try await self.request(request, debugger: nil, breadcrumbs: breadcrumbs)
    }

    func request<Request: ApiRequest & Encodable, Response: Decodable>(_ request: Request, breadcrumbs: Breadcrumbs?) async throws -> Response {
        try await self.request(request, breadcrumbs: breadcrumbs).response
    }
}

// @available(*, deprecated, message: "Leave breadcrumbs")
@_spi(Aiuta) public extension ApiService {
    func request<Request: ApiRequest & Encodable, Response: Decodable>(_ request: Request, debugger: ApiDebuggerOperation?) async throws -> Response {
        try await self.request(request, debugger: debugger, breadcrumbs: nil).response
    }

    func request<Request: ApiRequest & Encodable, Response: Decodable>(_ request: Request) async throws -> ApiResponse<Response> {
        try await self.request(request, debugger: nil, breadcrumbs: nil)
    }

    func request<Request: ApiRequest & Encodable, Response: Decodable>(_ request: Request) async throws -> Response {
        try await self.request(request, breadcrumbs: nil).response
    }
}
