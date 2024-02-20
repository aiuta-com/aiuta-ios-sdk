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

import AiutaKit
import Alamofire
import Foundation

protocol ApiRequest {
    var urlPath: String { get }
    var title: String { get }
    var subtitle: String? { get }
    var query: ApiQuery? { get }
    var method: HTTPMethod { get }
    var type: ApiRequestType { get }
    var requireAuth: Bool { get }
    var headers: HTTPHeaders { get }
    var hasBody: Bool { get }

    func multipartFormData(_ data: MultipartFormData)
}

extension ApiRequest {
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

enum ApiRequestType {
    case plain, json, upload
}

extension HTTPHeaders: Encodable {
    public func encode(to encoder: Encoder) throws {
        // nop
    }

    func value(for name: String) -> String? {
        first(where: { $0.name == name })?.value
    }

    var etag: String? { value(for: "Etag") }
}

final class ApiQuery: Encodable {
    private(set) var items: [URLQueryItem] = []

    func append(_ newItems: [URLQueryItem]?) {
        guard let newItems, !newItems.isEmpty else { return }
        items.append(contentsOf: newItems)
    }

    func append(_ item: URLQueryItem?) {
        guard let item, item.value.isSome else { return }
        items.append(item)
    }

    func append(key: String, value: String?) {
        guard let value else { return }
        append(URLQueryItem(name: key, value: value))
    }

    func before(value: String?) {
        append(key: "before", value: value)
    }

    func after(value: String?) {
        append(key: "after", value: value)
    }

    func limit(_ max: Int) {
        append(key: "limit", value: "\(max)")
    }

    func encode(to encoder: Encoder) throws {}
}
