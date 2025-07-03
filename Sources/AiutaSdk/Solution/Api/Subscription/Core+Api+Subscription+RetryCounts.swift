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
import Foundation

extension Aiuta.SubscriptionDetails {
    struct RetryCounts: Codable {
        let photoUpload: Int
        let operationStart: Int
        let operationStatus: Int
        let resultDownload: Int

        init(from decoder: Decoder) throws {
            let defaults = RetryCounts()
            let container = try decoder.container(keyedBy: CodingKeys.self)
            photoUpload = try container.decodeIfPresent(Int.self, forKey: .photoUpload) ?? defaults.photoUpload
            operationStart = try container.decodeIfPresent(Int.self, forKey: .operationStart) ?? defaults.operationStart
            operationStatus = try container.decodeIfPresent(Int.self, forKey: .operationStatus) ?? defaults.operationStatus
            resultDownload = try container.decodeIfPresent(Int.self, forKey: .resultDownload) ?? defaults.resultDownload
        }
    }
}
