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

extension Aiuta {
    /// A event occurring in the SDK in respond to user action or state changes
    /// that an host application can send to its own analytics.
    public enum Event {
        case page(pageId: Page),
             onboarding(event: Onboarding),
             picker(pageId: Page, event: Picker),
             tryOn(event: TryOn),
             results(pageId: Page, event: Results, productId: String),
             feedback(event: Feedback),
             history(event: History),
             exit(pageId: Page)
    }
}

extension Aiuta.Event {
    public enum Page: String, Encodable, RawRepresentable {
        case welcome,
             howItWorks,
             bestResults,
             consent,
             imagePicker,
             loading,
             results,
             history
    }

    public enum Onboarding: String, Encodable, RawRepresentable {
        case welcomeStartClicked,
             consentGiven,
             onboardingFinished
    }

    public enum Picker: String, Encodable, RawRepresentable {
        case cameraOpened,
             newPhotoTaken,
             photoGalleryOpened,
             galleryPhotoSelected,
             uploadsHistoryOpened,
             uploadedPhotoSelected,
             uploadedPhotoDeleted
    }

    public enum TryOn: String, Encodable, RawRepresentable {
        case photoUploaded,
             tryOnStarted,
             tryOnFinished,
             tryOnError
    }

    public enum Results: String, Encodable, RawRepresentable {
        case resultShared,
             productAddToWishlist,
             productAddToCart,
             pickOtherPhoto
    }

    public enum Feedback: RawRepresentable {
        case positive,
             negative(option: Int?, text: String?)
    }

    public enum History: String, Encodable, RawRepresentable {
        case generatedImageShared,
             generatedImageDeleted
    }
}

// MARK: - Conversion to common Analytics event names and parameters

public extension Aiuta.Event {
    func name(withPrefix prefix: String = "", suffix: String = "Event", firstCapitalized: Bool = true) -> String {
        let isFirstCapitalized = !prefix.isEmpty || firstCapitalized
        let name = isFirstCapitalized ? rawValue.firstCapitalized : rawValue
        return "\(prefix)\(name)\(suffix)"
    }

    func parameters() -> [String: Any?] {
        var params = [String: Any?]()
        switch self {
            case let .page(pageId):
                params[pageId.codingKey.rawValue] = pageId.rawValue
            case let .onboarding(event):
                params[event.codingKey.rawValue] = event.rawValue
            case let .picker(pageId, event):
                params[event.codingKey.rawValue] = event.rawValue
                params[pageId.codingKey.rawValue] = pageId.rawValue
            case let .tryOn(event):
                params[event.codingKey.rawValue] = event.rawValue
            case let .results(pageId, event, productId):
                params[event.codingKey.rawValue] = event.rawValue
                params[pageId.codingKey.rawValue] = pageId.rawValue
                params[event.codingPriductKey.rawValue] = productId
            case let .feedback(event):
                params[event.codingKey.rawValue] = event.rawValue
                switch event {
                    case .positive: break
                    case let .negative(option, text):
                        if let text { params[event.codingNegativeTextKey.rawValue] = text }
                        if let option { params[event.codingNegativeOptionKey.rawValue] = option }
                }
            case let .history(event):
                params[event.codingKey.rawValue] = event.rawValue
            case let .exit(pageId):
                params[pageId.codingKey.rawValue] = pageId.rawValue
        }
        return params
    }
}

// MARK: - Custom Raw values & parameter names

public extension Aiuta.Event {
    private enum Raw: String {
        case page,
             onboarding,
             picker,
             tryOn,
             results,
             feedback,
             history,
             exit
    }

    var rawValue: String {
        let raw: Raw
        switch self {
            case .page: raw = .page
            case .onboarding: raw = .onboarding
            case .picker: raw = .picker
            case .tryOn: raw = .tryOn
            case .results: raw = .results
            case .feedback: raw = .feedback
            case .history: raw = .history
            case .exit: raw = .exit
        }
        return raw.rawValue
    }
}

public extension Aiuta.Event.Feedback {
    private enum Raw: String {
        case positive,
             negative
    }

    init?(rawValue: String) {
        switch rawValue {
            case Raw.positive.rawValue: self = .positive
            case Raw.negative.rawValue: self = .negative(option: nil, text: nil)
            default: return nil
        }
    }

    var rawValue: String {
        let raw: Raw
        switch self {
            case .positive: raw = .positive
            case .negative: raw = .negative
        }
        return raw.rawValue
    }
}

public extension Aiuta.Event.Page {
    var codingKey: Aiuta.Event.CodingKeys { .pageId }
}

public extension Aiuta.Event.Feedback {
    var codingKey: Aiuta.Event.CodingKeys { .event }
    var codingNegativeTextKey: Aiuta.Event.CodingKeys { .negativeFeedbackText }
    var codingNegativeOptionKey: Aiuta.Event.CodingKeys { .negativeFeedbackOptionIndex }
}

public extension Aiuta.Event.History {
    var codingKey: Aiuta.Event.CodingKeys { .event }
}

public extension Aiuta.Event.TryOn {
    var codingKey: Aiuta.Event.CodingKeys { .event }
}

public extension Aiuta.Event.Picker {
    var codingKey: Aiuta.Event.CodingKeys { .event }
}

public extension Aiuta.Event.Onboarding {
    var codingKey: Aiuta.Event.CodingKeys { .event }
}

public extension Aiuta.Event.Results {
    var codingKey: Aiuta.Event.CodingKeys { .event }
    var codingPriductKey: Aiuta.Event.CodingKeys { .productId }
}

// MARK: - Custom Encodable implementation

extension Aiuta.Event: Encodable {
    public enum CodingKeys: String, CodingKey {
        case type, event, pageId, productId,
             negativeFeedbackOptionIndex, negativeFeedbackText
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name(firstCapitalized: false), forKey: .type)
        switch self {
            case let .page(pageId):
                try container.encode(pageId.rawValue, forKey: pageId.codingKey)
            case let .onboarding(event):
                try container.encode(event.rawValue, forKey: event.codingKey)
            case let .picker(pageId, event):
                try container.encode(event.rawValue, forKey: event.codingKey)
                try container.encode(pageId.rawValue, forKey: pageId.codingKey)
            case let .tryOn(event):
                try container.encode(event.rawValue, forKey: event.codingKey)
            case let .results(pageId, event, productId):
                try container.encode(event.rawValue, forKey: event.codingKey)
                try container.encode(pageId.rawValue, forKey: pageId.codingKey)
                try container.encode(productId, forKey: event.codingPriductKey)
            case let .feedback(event):
                try container.encode(event.rawValue, forKey: event.codingKey)
                switch event {
                    case .positive: break
                    case let .negative(option, text):
                        try container.encodeIfPresent(text, forKey: event.codingNegativeTextKey)
                        try container.encodeIfPresent(option, forKey: event.codingNegativeOptionKey)
                }
            case let .history(event):
                try container.encode(event.rawValue, forKey: event.codingKey)
            case let .exit(pageId):
                try container.encode(pageId.rawValue, forKey: pageId.codingKey)
        }
    }
}
