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
    struct FitSurvey: Codable, Equatable {
        let age: Int
        let height: Int
        let weight: Int
        let gender: SizeRecommendation.Gender
    }

    struct SizeRecommendation: Codable {
        let recommendedSizeName: String
        let sizes: [Size]
        let bodyMeasurements: [BodyMeasurement]
    }
}

extension Aiuta.SizeRecommendation {
    enum MeasurementType: String {
        case chest_c, waist_c, hip_c
        case bmi, inseam
        case cup, bra_underbust, over_bust, under_bust
        case unknown
    }

    struct Size: Codable {
        let name: String
        let measurements: [ItemMeasurement]
    }

    struct ItemMeasurement: Codable {
        let type: MeasurementType
        let fitRatio: Double
    }

    struct BodyMeasurement: Codable {
        let type: MeasurementType
        let value: Double
    }

    enum Gender: String, Codable {
        case male = "Male"
        case female = "Female"
    }
}

extension Aiuta.SizeRecommendation.MeasurementType: Codable {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
