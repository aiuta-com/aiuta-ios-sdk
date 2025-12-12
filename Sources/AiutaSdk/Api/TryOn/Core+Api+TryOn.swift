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

import AiutaCore
@_spi(Aiuta) import AiutaKit
import Foundation

extension Aiuta {
    struct TryOnStart: Codable {
        let operationId: String
        let details: String?
        let errors: [String]
    }

    struct TryOnOperation: Codable, Equatable {
        enum Status: String {
            // pending
            case created = "CREATED"
            case inProgress = "IN_PROGRESS"
            
            // ok
            case success = "SUCCESS"
            
            // fails
            case failed = "FAILED"
            case aborted = "ABORTED"
            case cancelled = "CANCELLED"
            case unknown
        }

        let id: String
        let status: Status
        let error: String?
        let generatedImages: [Image]
    }
}

extension Aiuta.TryOnOperation: LocalizedError {
    public var errorDescription: String? {
        return error ?? "Unknown error"
    }
}

extension Aiuta.TryOnOperation.Status: Codable {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
