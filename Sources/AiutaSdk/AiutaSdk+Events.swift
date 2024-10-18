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
                params[pageId.parameterName] = pageId.rawValue
            case let .onboarding(event):
                params[event.parameterName] = event.rawValue
            case let .picker(pageId, event):
                params[event.parameterName] = event.rawValue
                params[pageId.parameterName] = pageId.rawValue
            case let .tryOn(event):
                params[event.parameterName] = event.rawValue
            case let .results(pageId, event, productId):
                params[event.parameterName] = event.rawValue
                params[pageId.parameterName] = pageId.rawValue
                params[event.parameterProductIdName] = productId
            case let .feedback(event):
                params[event.parameterName] = event.rawValue
                switch event {
                    case .positive: break
                    case let .negative(option, text):
                        if let text { params[event.parameterNegativeTextName] = text }
                        if let option { params[event.parameterNegativeOptionName] = option }
                }
            case let .history(event):
                params[event.parameterName] = event.rawValue
            case let .exit(pageId):
                params[pageId.parameterName] = pageId.rawValue
        }
        return params
    }
}

// MARK: - Custom Raw values & parameter names

public extension Aiuta.Event {
    var rawValue: String {
        switch self {
            case .page: return "page"
            case .onboarding: return "onboarding"
            case .picker: return "picker"
            case .tryOn: return "tryOn"
            case .results: return "results"
            case .feedback: return "feedback"
            case .history: return "history"
            case .exit: return "exit"
        }
    }
}

public extension Aiuta.Event.Feedback {
    init?(rawValue: String) {
        switch rawValue {
            case "positive": self = .positive
            case "negative": self = .negative(option: nil, text: nil)
            default: return nil
        }
    }

    var rawValue: String {
        switch self {
            case .positive: return "positive"
            case .negative: return "negative"
        }
    }
}

public extension Aiuta.Event.Page {
    var parameterName: String { "pageId" }
}

public extension Aiuta.Event.Feedback {
    var parameterName: String { "event" }
    var parameterNegativeTextName: String { "negativeFeedbackText" }
    var parameterNegativeOptionName: String { "negativeFeedbackOptionIndex" }
}

public extension Aiuta.Event.History {
    var parameterName: String { "event" }
}

public extension Aiuta.Event.TryOn {
    var parameterName: String { "event" }
}

public extension Aiuta.Event.Picker {
    var parameterName: String { "event" }
}

public extension Aiuta.Event.Onboarding {
    var parameterName: String { "event" }
}

public extension Aiuta.Event.Results {
    var parameterName: String { "event" }
    var parameterProductIdName: String { "productId" }
}
