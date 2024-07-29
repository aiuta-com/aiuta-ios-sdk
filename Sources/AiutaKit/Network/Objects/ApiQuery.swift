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

@_spi(Aiuta) public final class ApiQuery {
    public private(set) var items: [URLQueryItem] = []

    public init() {}
}

@_spi(Aiuta) public extension ApiQuery {
    func append(_ newItems: [URLQueryItem]?) {
        guard let newItems, !newItems.isEmpty else { return }
        items.append(contentsOf: newItems)
    }

    func append(_ item: URLQueryItem?) {
        guard let item, item.value.isSome else { return }
        items.append(item)
    }

    func append(_ representable: QueryRepresentable?) {
        guard let representable else { return }
        append(representable.queryItems)
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
}

@_spi(Aiuta) extension ApiQuery: Encodable {
    public func encode(to encoder: Encoder) throws {
        // TODO: nop?
    }
}

@_spi(Aiuta) public protocol QueryRepresentable {
    var queryItems: [URLQueryItem] { get }
}
