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


extension Aiuta {
    struct TryOnStart: Codable {
        let operationId: String
        let details: String?
        let errors: [String]
    }

    struct TryOnOperation: Codable, Equatable {
        enum Status: String {
            case created = "CREATED"
            case inProgress = "IN_PROGRESS"
            case success = "SUCCESS"
            case failed = "FAILED"
            case unknown
        }

        let id: String
        let status: Status
        let error: String?
        let generatedImages: [GeneratedImage]
    }
}

extension Aiuta.TryOnStart {
    struct Post: Encodable, ApiRequest {
        var urlPath: String { "sku_images_operations" }
        var method: HTTPMethod { .post }

        let uploadedImageId: String
        let skuId: String
        let skuCatalogName: String
    }
}

extension Aiuta.TryOnOperation {
    struct Get: Encodable, ApiRequest {
        var urlPath: String { "sku_images_operations/\(operationId)" }

        let operationId: String
    }
}

extension Aiuta.TryOnOperation.Status: Codable {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
