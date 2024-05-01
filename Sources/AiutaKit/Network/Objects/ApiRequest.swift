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

@_spi(Aiuta) public enum ApiRequestType {
    case plain, json, upload
}

@_spi(Aiuta) public protocol ApiRequest {
    var urlPath: String { get }
    var type: ApiRequestType { get }
    var title: String { get }
    var subtitle: String? { get }
    var query: ApiQuery? { get }
    var method: HTTPMethod { get }
    var requireAuth: Bool { get }
    var headers: HTTPHeaders { get }
    var hasBody: Bool { get }

    func multipartFormData(_ data: MultipartFormData)
}

@_spi(Aiuta) public extension ApiRequest {
    var method: HTTPMethod { .get }
    var type: ApiRequestType { .json }
    var requireAuth: Bool { true }
    var query: ApiQuery? { nil }
    var headers: HTTPHeaders { [] }
    var title: String { "\(method.rawValue.lowercased().firstCapitalized) \(urlPath.replacingOccurrences(of: "_", with: " "))" }
    var subtitle: String? { nil }
    var idString: String { "\(urlPath)-\(self)" }
    var hasBody: Bool {
        switch method {
            case .post, .put: return true
            default: return false
        }
    }

    func multipartFormData(_ data: MultipartFormData) {}
}
