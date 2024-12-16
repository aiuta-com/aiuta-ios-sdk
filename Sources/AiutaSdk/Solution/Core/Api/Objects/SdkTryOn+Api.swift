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
import Resolver

extension Aiuta.TryOnStart {
    struct Post: Encodable, ApiRequest {
        var urlPath: String { "sku_images_operations" }
        var method: HTTPMethod { .post }

        let uploadedImageId: String
        let skuId: String
        let skuCatalogName: String?

        var secureAuthFields: [String: String]? {
            var fields = [
                "sku_id": skuId,
                "uploaded_image_id": uploadedImageId,
            ]
            if let skuCatalogName {
                fields["sku_catalog_name"] = skuCatalogName
            }
            return fields
        }

        var retryCount: Int {
            @injected var subscription: SubscriptionModel
            return subscription.retryCounts.operationStart
        }
    }
}

extension Aiuta.TryOnOperation {
    struct Get: Encodable, ApiRequest {
        var urlPath: String { "sku_images_operations/\(operationId)" }

        let operationId: String

        var retryCount: Int {
            @injected var subscription: SubscriptionModel
            return subscription.retryCounts.operationStatus
        }
    }
}
