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

    enum FitIssueSeverity: Int, Comparable {
        case slight = 1
        case noticeable = 2
        case outOfRange = 3

        static func < (lhs: FitIssueSeverity, rhs: FitIssueSeverity) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }

    struct FitIssue {
        let message: String
        let severity: FitIssueSeverity
        let absFitRatio: Double
        let type: MeasurementType
    }

    enum FitTone {
        case slight
        case mayFeel
        case exact
    }

    enum FitDirection {
        case tight
        case loose
    }

    struct FitGroupKey: Hashable {
        let direction: FitDirection
        let tone: FitTone
    }
}

extension Aiuta.SizeRecommendation.MeasurementType: Codable {
    init(from decoder: Decoder) throws {
        self = try Self(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

extension Array where Element == Aiuta.SizeRecommendation.ItemMeasurement {
    func fitDirection(from fitRatio: Double) -> Aiuta.SizeRecommendation.FitDirection {
        // API: fitRatio > 0 => body smaller => loose
        fitRatio > 0 ? .loose : .tight
    }

    func fitTone(absFitRatio: Double) -> Aiuta.SizeRecommendation.FitTone? {
        switch absFitRatio {
            case 0 ..< 0.20:
                return nil
            case 0.20 ..< 0.45:
                return .slight
            case 0.45 ..< 1.00:
                return .mayFeel
            default:
                return .exact
        }
    }

    func directionText(_ direction: Aiuta.SizeRecommendation.FitDirection) -> String {
        switch direction {
            case .tight: return "tight"
            case .loose: return "loose"
        }
    }

    func placeText(_ type: Aiuta.SizeRecommendation.MeasurementType) -> String {
        switch type {
            case .chest_c: return "chest"
            case .waist_c: return "waist"
            case .hip_c: return "hips"
            case .over_bust: return "bust"
            default: return ""
        }
    }

    func fitSummary(isRecommended: Bool) -> String? {
        // collect relevant issues
        let issues: [(tone: Aiuta.SizeRecommendation.FitTone, direction: Aiuta.SizeRecommendation.FitDirection, place: String)] =
            compactMap { m in
                let absRatio = abs(m.fitRatio)

                guard
                    let tone = fitTone(absFitRatio: absRatio),
                    let place = {
                        let p = placeText(m.type)
                        return p.isEmpty ? nil : p
                    }()
                else {
                    return nil
                }

                return (
                    tone: tone,
                    direction: fitDirection(from: m.fitRatio),
                    place: place
                )
            }

        guard !issues.isEmpty else {
            return isRecommended ? "Best fit" : nil
        }

        let grouped = Dictionary(grouping: issues) {
            Aiuta.SizeRecommendation.FitGroupKey(direction: $0.direction, tone: $0.tone)
        }

        let phrases: [String] = grouped.map { key, values in
            let places = values
                .map(\.place)
                .sorted()
                .joined(separator: " and ")

            switch key.tone {
                case .slight:
                    return "slightly \(directionText(key.direction)) in \(places)"
                case .mayFeel:
                    return "may feel \(directionText(key.direction)) in \(places)"
                case .exact:
                    return "\(directionText(key.direction)) in \(places)"
            }
        }

        let body = phrases.sorted().joined(separator: phrases.count == 2 ? " and " : ", ")
        return body.firstCapitalized
    }
}

extension Aiuta.SizeRecommendation {
    var recommendedSize: Size? {
        sizes.first(where: { $0.name == recommendedSizeName })
    }

    struct ConfidenceConfig {
        /// Falloff stiffness (0.6...1.2 is usually fine)
        var k: Double = 0.8

        /// Penalize tight (fitRatio < 0) stronger than loose
        var tightPenaltyMultiplier: Double = 1.6

        /// Measurement weights (can be adjusted per code/category)
        var measurementWeights: [MeasurementType: Double] = [
            .waist_c: 2.0,
            .hip_c: 1.2,
            .chest_c: 2.0,
            .over_bust: 1.0,
            .under_bust: 1.5,
            .bra_underbust: 1.5,
            // cup/bmi/inseam usually don't appear in sizes[].measurements for clothing,
            // but if they do — they'll fall back to defaultWeight
        ]

        var defaultWeight: Double = 1.0
    }

    /// For this API: fitRatio < 0 => tight, fitRatio > 0 => loose
    private func isTight(_ fitRatio: Double) -> Bool { fitRatio < 0 }

    /// Absolute confidence 0...1 (NOT normalized, depends only on the fitRatio grid).
    func absoluteConfidence(for size: Size, config: ConfidenceConfig = .init()) -> Double {
        guard !size.measurements.isEmpty else { return 0 }

        var sumWeights = 0.0
        var sumWeightedLog = 0.0

        for m in size.measurements {
            let w = config.measurementWeights[m.type] ?? config.defaultWeight
            let dirMult = isTight(m.fitRatio) ? config.tightPenaltyMultiplier : 1.0

            // soft per-measurement score
            let score = Foundation.exp(-config.k * abs(m.fitRatio) * dirMult)

            // geometric mean via logarithms
            sumWeights += w
            sumWeightedLog += w * Foundation.log(max(score, 1e-12)) // guard against log(0)
        }

        guard sumWeights > 0 else { return 0 }
        return Foundation.exp(sumWeightedLog / sumWeights)
    }

    func absoluteConfidencePercent(for size: Size, config: ConfidenceConfig = .init()) -> Int {
        Int((absoluteConfidence(for: size, config: config) * 100).rounded())
    }

    /// Ranking by absolute confidence (to choose the "next best" by quality).
    func rankedByAbsoluteConfidence(config: ConfidenceConfig = .init()) -> [(size: Size, confidence: Double)] {
        sizes
            .map { ($0, absoluteConfidence(for: $0, config: config)) }
            .sorted { $0.confidence > $1.confidence }
    }

    /// The "next" option: second-best by confidence (not necessarily adjacent size)
    func nextBestSize(config: ConfidenceConfig = .init()) -> Size? {
        let ranked = rankedByAbsoluteConfidence(config: config)
        guard let recIdx = ranked.firstIndex(where: { $0.size.name == recommendedSizeName }) else {
            return ranked.dropFirst().first?.size
        }
        // take the best one that is NOT equal to the recommended size
        return ranked.enumerated()
            .first(where: { $0.offset != recIdx })?
            .element.size
    }

    /// If you need an actual neighbor in the scale (e.g., 42/44/46), choose the better neighbor.
    func bestNeighborOfRecommended(config: ConfidenceConfig = .init()) -> Size? {
        guard let idx = sizes.firstIndex(where: { $0.name == recommendedSizeName }) else {
            return nil
        }

        let left: Size? = (idx > 0) ? sizes[idx - 1] : nil
        let right: Size? = (idx + 1 < sizes.count) ? sizes[idx + 1] : nil

        switch (left, right) {
            case (nil, nil):
                return nil
            case (let l?, nil):
                return l
            case (nil, let r?):
                return r
            case let (l?, r?):
                let cl = absoluteConfidence(for: l, config: config)
                let cr = absoluteConfidence(for: r, config: config)
                return (cl >= cr) ? l : r
        }
    }
}
