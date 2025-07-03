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

extension Aiuta {
    struct SubscriptionDetails: Codable {
        let poweredBySticker: PoweredBySticker
        let retryCounts: RetryCounts
        let operationDelaysSequence: OperationDelaysSequence

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            poweredBySticker = try container.decodeIfPresent(PoweredBySticker.self, forKey: .poweredBySticker) ?? PoweredBySticker()
            retryCounts = try container.decodeIfPresent(RetryCounts.self, forKey: .retryCounts) ?? RetryCounts()
            operationDelaysSequence = try container.decodeIfPresent(OperationDelaysSequence.self, forKey: .operationDelaysSequence) ?? OperationDelaysSequence()
        }
    }
}
