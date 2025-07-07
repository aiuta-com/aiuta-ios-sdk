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

// MARK: - Conversion to common Analytics event names and parameters

public extension Aiuta.Event {
    /// Generates a name for the event, optionally adding a prefix or suffix.
    ///
    /// - Parameters:
    ///   - prefix: A string to prepend to the event name.
    ///   - suffix: A string to append to the event name.
    ///   - firstCapitalized: Whether the first letter of the name should be capitalized.
    /// - Returns: A formatted event name as a string.
    func name(withPrefix prefix: String = "", suffix: String = "Event", firstCapitalized: Bool = true) -> String {
        let capitalizedName = (!prefix.isEmpty || firstCapitalized) ? rawValue.firstCapitalized : rawValue
        let capitalizedPrefix = firstCapitalized ? prefix.firstCapitalized : prefix
        return "\(capitalizedPrefix)\(capitalizedName)\(suffix.firstCapitalized)"
    }

    /// Converts the event into a dictionary of parameters for analytics.
    ///
    /// - Returns: A dictionary containing the event parameters.
    func parameters() -> [String: Any] {
        Dictionary(uniqueKeysWithValues: codingParameters().compactMap { k, v in
            guard let v else { return nil }
            return (k.rawValue, v)
        })
    }
}

// MARK: - Custom Raw values & parameter names

public extension Aiuta.Event {
    /// Represents the raw values for each event type.
    enum Raw: String, Sendable {
        case configure, session, page, onboarding, picker, tryOn, results, feedback, history, share, exit
    }

    /// Retrieves the raw value for the event type.
    var rawValue: String {
        type.rawValue
    }

    /// Simplified representation of the event without parameters.
    var type: Raw {
        switch self {
            case .configure: return .configure
            case .session: return .session
            case .page: return .page
            case .onboarding: return .onboarding
            case .picker: return .picker
            case .tryOn: return .tryOn
            case .results: return .results
            case .feedback: return .feedback
            case .history: return .history
            case .share: return .share
            case .exit: return .exit
        }
    }

    internal var rawEvent: String? {
        switch self {
            case .configure: return nil
            case let .page(p, _): return p.rawValue
            case let .exit(p, _): return p.rawValue
            case let .session(f, _): return f.rawValue
            case let .onboarding(e, _, _): return e.rawValue
            case let .picker(e, _, _): return e.rawValue
            case let .tryOn(e, _, _): return e.rawValue
            case let .results(e, _, _): return e.rawValue
            case let .feedback(e, _, _): return e.rawValue
            case let .history(e, _, _): return e.rawValue
            case let .share(e, _, _): return e.rawValue
        }
    }

    internal var rawQualifier: String {
        if let rawEvent {
            return "\(rawValue)/\(rawEvent)"
        } else {
            return rawValue
        }
    }
}

private extension Aiuta.Event.TryOn {
    /// Represents the raw values for try-on events.
    enum Raw: String {
        case initiated, photoUploaded, tryOnStarted, tryOnFinished, tryOnAborted, tryOnError
    }

    /// Retrieves the raw value for the try-on event type.
    var rawValue: String {
        type.rawValue
    }

    /// Simplified representation of the event without parameters.
    var type: Raw {
        switch self {
            case .initiated: return .initiated
            case .photoUploaded: return .photoUploaded
            case .tryOnStarted: return .tryOnStarted
            case .tryOnFinished: return .tryOnFinished
            case .tryOnAborted: return .tryOnAborted
            case .tryOnError: return .tryOnError
        }
    }
}

private extension Aiuta.Event.Feedback {
    /// Represents the raw values for feedback events.
    enum Raw: String {
        case positive, negative
    }

    /// Retrieves the raw value for the feedback event type.
    var rawValue: String {
        type.rawValue
    }

    /// Simplified representation of the event without parameters.
    var type: Raw {
        switch self {
            case .positive: return .positive
            case .negative: return .negative
        }
    }
}

private extension Aiuta.Event.Onboarding {
    /// Represents the raw values for onboarding events.
    enum Raw: String {
        case welcomeStartClicked, consentsGiven, onboardingFinished
    }

    /// Retrieves the raw value for the onboarding event.
    var rawValue: String {
        type.rawValue
    }

    /// Simplified representation of the event without parameters.
    var type: Raw {
        switch self {
            case .welcomeStartClicked: return .welcomeStartClicked
            case .consentsGiven: return .consentsGiven
            case .onboardingFinished: return .onboardingFinished
        }
    }
}

private extension Aiuta.Event.Share {
    /// Represents the raw values for share events.
    enum Raw: String {
        case initiated, succeeded, canceled, failed, screenshot
    }

    /// Retrieves the raw value for the share event.
    var rawValue: String {
        type.rawValue
    }

    /// Simplified representation of the event without parameters.
    var type: Raw {
        switch self {
            case .initiated: return .initiated
            case .succeeded: return .succeeded
            case .canceled: return .canceled
            case .failed: return .failed
            case .screenshot: return .screenshot
        }
    }
}

private extension Aiuta.Auth {
    /// Represents the raw values for authentication types.
    enum Raw: String {
        case apiKey, jwt
    }

    /// Retrieves the raw value for the authentication type.
    var rawValue: String {
        type.rawValue
    }

    /// Simplified representation of the authentication type.
    var type: Raw {
        switch self {
            case .apiKey: return .apiKey
            case .jwt: return .jwt
        }
    }
}

private extension Sdk.Configuration.Features.Consent {
    /// Represents the raw values for consent feature types.
    enum Raw: String {
        case embeddedIntoOnboarding, standaloneOnboardingPage, standaloneImagePickerPage
    }

    /// Retrieves the raw value for the consent feature type.
    var rawValue: String? {
        type?.rawValue
    }

    /// Simplified representation of the consent feature type.
    var type: Raw? {
        if isEmbedded { return .embeddedIntoOnboarding }
        if isOnboarding { return .standaloneOnboardingPage }
        if isUploadButton { return .standaloneImagePickerPage }
        return nil
    }
}

// MARK: - Custom Encodable implementation

extension Aiuta.Event: Encodable {
    /// Encodes the event into the provided encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    /// - Throws: An error if encoding fails.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        for (codingKey, value) in codingParameters() {
            switch value {
                case let v as Int: try container.encode(v, forKey: codingKey)
                case let v as String: try container.encode(v, forKey: codingKey)
                case let v as Double: try container.encode(v, forKey: codingKey)
                case let v as Float: try container.encode(v, forKey: codingKey)
                case let v as Bool: try container.encode(v, forKey: codingKey)
                case let v as [Any]: try container.encodeIfPresent(v, forKey: codingKey)
                case let v as [String: Any]: try container.encodeIfPresent(v, forKey: codingKey)
                default: break
            }
        }
    }

    /// Represents the coding keys used for encoding events.
    fileprivate enum CodingKeys: String, CodingKey {
        /// General fields
        case type, event, flow, origin

        /// Identifiers
        case pageId, productIds, consentIds, targetId

        /// Try-On fields
        case uploadDuration, tryOnDuration, downloadDuration, totalDuration,
             abortReason, errorType, errorMessage

        /// Feedback fields
        case negativeFeedbackOptionIndex, negativeFeedbackText

        /// Configuration fields
        case authType,
             welcomeScreenFeatureEnabled,
             onboardingFeatureEnabled,
             onboardingBestResultsPageFeatureEnabled,
             consentFeatureType,
             imagePickerCameraFeatureEnabled,
             imagePickerPredefinedModelFeatureEnabled,
             imagePickerUploadsHistoryFeatureEnabled,
             tryOnFitDisclaimerFeatureEnabled,
             tryOnFeedbackFeatureEnabled,
             tryOnFeedbackOtherFeatureEnabled,
             tryOnGenerationsHistoryFeatureEnabled,
             tryOnWithOtherPhotoFeatureEnabled,
             shareFeatureEnabled,
             shareWatermarkFeatureEnabled,
             wishlistFeatureEnabled
    }

    /// Maps the event to its corresponding coding parameters.
    /// To be used for encoding the event into a dictionary format
    /// and custom encode implementation.
    ///
    /// - Returns: A dictionary of coding keys and their associated values.
    fileprivate func codingParameters() -> [CodingKeys: Any?] {
        var parameters = eventParameters()
        parameters[.type] = rawValue
        return parameters
    }

    /// Maps event parameters to its corresponding coding parameters.
    private func eventParameters() -> [CodingKeys: Any?] {
        switch self {
            case .configure:
                @injected var config: Sdk.Configuration
                return [
                    .authType: config.auth.type.rawValue,
                    .consentFeatureType: config.features.consent.type?.rawValue,
                    .welcomeScreenFeatureEnabled: config.features.welcomeScreen.isEnabled,
                    .onboardingFeatureEnabled: config.features.onboarding.isEnabled,
                    .onboardingBestResultsPageFeatureEnabled: config.features.onboarding.hasBestResults,
                    .imagePickerCameraFeatureEnabled: config.features.imagePicker.hasCamera,
                    .imagePickerPredefinedModelFeatureEnabled: config.features.imagePicker.hasPredefinedModels,
                    .imagePickerUploadsHistoryFeatureEnabled: config.features.imagePicker.hasUploadsHistory,
                    .tryOnFitDisclaimerFeatureEnabled: config.features.tryOn.showsFitDisclaimerOnResults,
                    .tryOnFeedbackFeatureEnabled: config.features.tryOn.askForUserFeedbackOnResults,
                    .tryOnFeedbackOtherFeatureEnabled: config.features.tryOn.askForOtherFeedbackOnResults,
                    .tryOnGenerationsHistoryFeatureEnabled: config.features.tryOn.hasGenerationsHistory,
                    .tryOnWithOtherPhotoFeatureEnabled: config.features.tryOn.canContinueWithOtherPhoto,
                    .shareFeatureEnabled: config.features.share.isEnabled,
                    .shareWatermarkFeatureEnabled: config.features.share.isEnabled && config.images.shareWatermark.isSome,
                    .wishlistFeatureEnabled: config.features.wishlist.isEnabled,
                ]

            case let .session(flow, productIds): return [
                    .flow: flow.rawValue,
                    .productIds: productIds,
                ]

            case let .page(pageId, productIds),
                 let .exit(pageId, productIds): return [
                    .pageId: pageId.rawValue,
                    .productIds: productIds,
                ]

            case let .onboarding(event, pageId, productIds):
                switch event {
                    case .welcomeStartClicked, .onboardingFinished: return [
                            .event: event.rawValue,
                            .pageId: pageId.rawValue,
                            .productIds: productIds,
                        ]
                    case let .consentsGiven(consentIds): return [
                            .event: event.rawValue,
                            .pageId: pageId.rawValue,
                            .productIds: productIds,
                            .consentIds: consentIds,
                        ]
                }

            case let .picker(event, page, productIds): return [
                    .event: event.rawValue,
                    .pageId: page.rawValue,
                    .productIds: productIds,
                ]

            case let .tryOn(event, page, productIds):
                switch event {
                    case let .initiated(origin),
                         let .tryOnStarted(origin): return [
                            .event: event.rawValue,
                            .pageId: page.rawValue,
                            .productIds: productIds,
                            .origin: origin.rawValue,
                        ]
                    case .photoUploaded: return [
                            .event: event.rawValue,
                            .pageId: page.rawValue,
                            .productIds: productIds,
                        ]
                    case let .tryOnFinished(uploadDuration,
                                            tryOnDuration,
                                            downloadDuration,
                                            totalDuration): return [
                            .event: event.rawValue,
                            .pageId: page.rawValue,
                            .productIds: productIds,
                            .uploadDuration: uploadDuration,
                            .tryOnDuration: tryOnDuration,
                            .downloadDuration: downloadDuration,
                            .totalDuration: totalDuration,
                        ]
                    case let .tryOnAborted(reason): return [
                            .event: event.rawValue,
                            .pageId: page.rawValue,
                            .productIds: productIds,
                            .abortReason: reason.rawValue,
                        ]
                    case let .tryOnError(type, message): return [
                            .event: event.rawValue,
                            .pageId: page.rawValue,
                            .productIds: productIds,
                            .errorType: type.rawValue,
                            .errorMessage: message,
                        ]
                }

            case let .results(event, page, productIds): return [
                    .event: event.rawValue,
                    .pageId: page.rawValue,
                    .productIds: productIds,
                ]

            case let .feedback(event, page, productIds):
                switch event {
                    case .positive: return [
                            .event: event.rawValue,
                            .pageId: page.rawValue,
                            .productIds: productIds,
                        ]
                    case let .negative(option, text): return [
                            .event: event.rawValue,
                            .pageId: page.rawValue,
                            .productIds: productIds,
                            .negativeFeedbackText: text,
                            .negativeFeedbackOptionIndex: option,
                        ]
                }

            case let .history(event, page, productIds): return [
                    .event: event.rawValue,
                    .pageId: page.rawValue,
                    .productIds: productIds,
                ]

            case let .share(event, page, productIds):
                switch event {
                    case .initiated, .screenshot: return [
                            .event: event.rawValue,
                            .pageId: page.rawValue,
                            .productIds: productIds,
                        ]
                    case let .succeeded(targetId),
                         let .canceled(targetId),
                         let .failed(targetId): return [
                            .event: event.rawValue,
                            .pageId: page.rawValue,
                            .productIds: productIds,
                            .targetId: targetId,
                        ]
                }
        }
    }
}
