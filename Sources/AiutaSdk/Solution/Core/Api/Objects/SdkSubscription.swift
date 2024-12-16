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

// MARK: - PoweredBySticker

extension Aiuta.SubscriptionDetails {
    struct PoweredBySticker: Codable {
        let urlIos: String?
        let isVisible: Bool

        init(from decoder: Decoder) throws {
            let defaults = PoweredBySticker()
            let container = try decoder.container(keyedBy: CodingKeys.self)
            urlIos = try container.decodeIfPresent(String.self, forKey: .urlIos) ?? defaults.urlIos
            isVisible = try container.decodeIfPresent(Bool.self, forKey: .isVisible) ?? defaults.isVisible
        }
    }
}

// MARK: - RetryCounts

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

// MARK: - OperationDelaysSequence

extension Aiuta.SubscriptionDetails {
    struct OperationDelaysSequence {
        private var sequence: [OperationDelay]
        private var index: Int = 0

        init() {
            sequence = OperationDelay.defaultSequence
        }
    }
}

extension Aiuta.SubscriptionDetails.OperationDelaysSequence: IteratorProtocol {
    mutating func next() -> AsyncDelayTime? {
        while index < sequence.count {
            if let time = sequence[index].next() {
                return .custom(time)
            }
            index += 1
        }
        return nil
    }
}

extension Aiuta.SubscriptionDetails.OperationDelaysSequence: Codable {
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let sequence = try container.decode([OperationDelay].self)
        self.sequence = sequence.isEmpty ? OperationDelay.defaultSequence : sequence
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(sequence)
    }
}

// MARK: - OperationDelay

extension Aiuta.SubscriptionDetails.OperationDelaysSequence {
    struct OperationDelay {
        enum Mode {
            case recurring(Int), infinite, unknown
        }

        let mode: Mode
        let delay: TimeInterval
        private var index: Int = 0
    }
}

extension Aiuta.SubscriptionDetails.OperationDelaysSequence.OperationDelay: IteratorProtocol {
    mutating func next() -> TimeInterval? {
        switch mode {
            case let .recurring(count):
                defer { index += 1 }
                return index < count ? delay : nil
            case .infinite:
                return delay
            case .unknown:
                return nil
        }
    }
}

extension Aiuta.SubscriptionDetails.OperationDelaysSequence.OperationDelay: Codable {
    private enum CodingKeys: String, CodingKey {
        case mode, delay, count = "repeat"
    }

    private enum ModeKeys: String {
        case recurring, infinite
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let modeString = try container.decodeIfPresent(String.self, forKey: .mode)
        switch modeString {
            case ModeKeys.recurring.rawValue:
                let count = try container.decodeIfPresent(Int.self, forKey: .count) ?? 0
                mode = count > 0 ? .recurring(count) : .unknown
            case ModeKeys.infinite.rawValue:
                mode = .infinite
            default:
                mode = .unknown
        }
        delay = try container.decodeIfPresent(TimeInterval.self, forKey: .delay) ?? 0
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch mode {
            case let .recurring(count):
                try container.encode(ModeKeys.recurring.rawValue, forKey: .mode)
                try container.encode(count, forKey: .count)
            case .infinite:
                try container.encode(ModeKeys.infinite.rawValue, forKey: .mode)
            default:
                break
        }
        try container.encode(delay, forKey: .delay)
    }
}
