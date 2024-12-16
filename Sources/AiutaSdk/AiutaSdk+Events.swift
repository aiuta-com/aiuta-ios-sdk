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
        case page(page: Page, product: Aiuta.Product?),
             onboarding(event: Onboarding, page: Page, product: Aiuta.Product?),
             picker(event: Picker, page: Page, product: Aiuta.Product?),
             tryOn(event: TryOn, message: String?, page: Page, product: Aiuta.Product?),
             results(event: Results, page: Page, product: Aiuta.Product?),
             feedback(event: Feedback, page: Page, product: Aiuta.Product?),
             history(event: History, page: Page, product: Aiuta.Product?),
             exit(page: Page, product: Aiuta.Product?)
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

    public enum Onboarding {
        case welcomeStartClicked,
             consentGiven(supplementary: [Aiuta.Consent]?),
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
             tryOnAborted,
             tryOnError
    }

    public enum Results: String, Encodable, RawRepresentable {
        case resultShared,
             productAddToWishlist,
             productAddToCart,
             pickOtherPhoto
    }

    public enum Feedback {
        case positive,
             negative(option: Int, text: String?)
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

    func parameters() -> [String: Any] {
        Dictionary(uniqueKeysWithValues: codingParameters().compactMap { k, v in
            guard let v else { return nil }
            return (k.rawValue, v)
        })
    }

    private func codingParameters() -> [CodingKeys: Any?] {
        switch self {
            case let .page(page, product): return [
                    .pageId: page.rawValue,
                    .productId: product?.skuId,
                ]
            case let .onboarding(event, page, product): return [
                    .event: event.rawValue,
                    .pageId: page.rawValue,
                    .productId: product?.skuId,
                ]
            case let .picker(event, page, product): return [
                    .event: event.rawValue,
                    .pageId: page.rawValue,
                    .productId: product?.skuId,
                ]
            case let .tryOn(event, message, page, product): return [
                    .event: event.rawValue,
                    .pageId: page.rawValue,
                    .productId: product?.skuId,
                    .errorMessage: message,
                ]
            case let .results(event, page, product): return [
                    .event: event.rawValue,
                    .pageId: page.rawValue,
                    .productId: product?.skuId,
                ]
            case let .feedback(event, page, product):
                switch event {
                    case .positive: return [
                            .event: event.rawValue,
                            .pageId: page.rawValue,
                            .productId: product?.skuId,
                        ]
                    case let .negative(option, text): return [
                            .event: event.rawValue,
                            .pageId: page.rawValue,
                            .productId: product?.skuId,
                            .negativeFeedbackText: text,
                            .negativeFeedbackOptionIndex: option,
                        ]
                }
            case let .history(event, page, product): return [
                    .event: event.rawValue,
                    .pageId: page.rawValue,
                    .productId: product?.skuId,
                ]
            case let .exit(page, product): return [
                    .pageId: page.rawValue,
                    .productId: product?.skuId,
                ]
        }
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

extension Aiuta.Event.Feedback: RawRepresentable {
    private enum Raw: String {
        case positive,
             negative
    }

    public init?(rawValue: String) {
        switch rawValue {
            case Raw.positive.rawValue: self = .positive
            case Raw.negative.rawValue: self = .negative(option: -1, text: nil)
            default: return nil
        }
    }

    public var rawValue: String {
        let raw: Raw
        switch self {
            case .positive: raw = .positive
            case .negative: raw = .negative
        }
        return raw.rawValue
    }
}

extension Aiuta.Event.Onboarding: RawRepresentable {
    private enum Raw: String {
        case welcomeStartClicked,
             consentGiven,
             onboardingFinished
    }

    public init?(rawValue: String) {
        switch rawValue {
            case Raw.welcomeStartClicked.rawValue: self = .welcomeStartClicked
            case Raw.consentGiven.rawValue: self = .consentGiven(supplementary: nil)
            case Raw.onboardingFinished.rawValue: self = .onboardingFinished
            default: return nil
        }
    }

    public var rawValue: String {
        let raw: Raw
        switch self {
            case .welcomeStartClicked: raw = .welcomeStartClicked
            case .consentGiven: raw = .consentGiven
            case .onboardingFinished: raw = .onboardingFinished
        }
        return raw.rawValue
    }
}

// MARK: - Custom Encodable implementation

extension Aiuta.Event: Encodable {
    public enum CodingKeys: String, CodingKey {
        case type, event, pageId, productId,
             negativeFeedbackOptionIndex, negativeFeedbackText,
             errorMessage,
             supplementaryConsents
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name(firstCapitalized: false), forKey: .type)
        switch self {
            case let .page(page, product):
                try container.encode(page.rawValue, forKey: .pageId)
                try container.encode(product.id, forKey: .productId)
            case let .onboarding(event, page, product):
                try container.encode(event.rawValue, forKey: .event)
                try container.encode(page.rawValue, forKey: .pageId)
                try container.encode(product.id, forKey: .productId)
                switch event {
                    case .welcomeStartClicked, .onboardingFinished: break
                    case let .consentGiven(supplementary):
                        try container.encode(supplementary, forKey: .supplementaryConsents)
                }
            case let .picker(event, page, product):
                try container.encode(event.rawValue, forKey: .event)
                try container.encode(page.rawValue, forKey: .pageId)
                try container.encode(product.id, forKey: .productId)
            case let .tryOn(event, message, page, product):
                try container.encode(event.rawValue, forKey: .event)
                try container.encodeIfPresent(message, forKey: .errorMessage)
                try container.encode(page.rawValue, forKey: .pageId)
                try container.encode(product.id, forKey: .productId)
            case let .results(event, page, product):
                try container.encode(event.rawValue, forKey: .event)
                try container.encode(page.rawValue, forKey: .pageId)
                try container.encode(product.id, forKey: .productId)
            case let .feedback(event, page, product):
                try container.encode(event.rawValue, forKey: .event)
                try container.encode(page.rawValue, forKey: .pageId)
                try container.encode(product.id, forKey: .productId)
                switch event {
                    case .positive: break
                    case let .negative(option, text):
                        try container.encodeIfPresent(text, forKey: .negativeFeedbackText)
                        try container.encode(option, forKey: .negativeFeedbackOptionIndex)
                }
            case let .history(event, page, product):
                try container.encode(event.rawValue, forKey: .event)
                try container.encode(page.rawValue, forKey: .pageId)
                try container.encode(product.id, forKey: .productId)
            case let .exit(page, product):
                try container.encode(page.rawValue, forKey: .pageId)
                try container.encode(product.id, forKey: .productId)
        }
    }
}
