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

extension Aiuta {
    struct Sku: Codable {
        let id: String
        let skuId: String
        let skuCatalogName: String
        let description: String
        let title: String
        let imageUrls: [String]
        let isReady: Bool
        let storeUrl: String?
    }
}

extension Aiuta.Sku {
    struct Get: Encodable, ApiRequest {
        var urlPath: String { "sku_items/\(skuCatalogName)/\(skuId)" }

        let skuId: String
        let skuCatalogName: String
    }
}

extension Aiuta.Sku: Equatable {
    static func == (lhs: Aiuta.Sku, rhs: Aiuta.Sku) -> Bool {
        lhs.id == rhs.id
    }
}
