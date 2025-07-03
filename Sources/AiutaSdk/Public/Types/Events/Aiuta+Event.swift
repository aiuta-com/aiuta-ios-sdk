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
    /// Represents an event that occurs within the SDK. These events are triggered
    /// in response to user actions or state changes. You can use these events
    /// to track user interactions or system behaviors in your analytics system.
    ///
    /// https://docs.aiuta.com/sdk/about/analytics/analytics/
    ///
    /// Although `Event` is an enum, it has an extension that provides convenient
    /// methods for creating common Annalytics names as Strings and parameters as
    /// Dictionaries with key-value pairs `[String: Any]` for each event type to
    /// ensure compatibility with the widespread analytics systems.
    ///
    /// Please refer to the following methods for generating names and parameters:
    /// - `name(withPrefix: suffix:) -> String` for generating event names.
    /// - `parameters() -> [String: Any]` for generating event parameters.
    public enum Event: Sendable {
        /// SDK was configured with a features set.
        ///
        /// - Parameters available as dictionary with `parameters()` method according
        /// to the https://docs.aiuta.com/sdk/about/analytics/analytics/#configuration
        ///
        /// - Note: Builds dinamically based on the configuration provided to the SDK.
        case configure

        /// Start of a new session, SDK about to present it's UI
        /// The page event is expected to be the following.
        ///
        /// - Parameters:
        ///  - flow: The flow that is being initiated, such as try-on or history.
        ///  - products: Products associated with the session.
        case session(flow: Flow, productIds: [String])

        /// Represents an event related to a specific page, such as navigating
        /// to or interacting with a page.
        ///
        /// - Parameters:
        ///   - page: The page where the event occurred.
        ///   - products: Products associated with the event.
        case page(pageId: Page, productIds: [String])

        /// Represents an event related to onboarding, such as completing
        /// onboarding steps or providing consent.
        ///
        /// - Parameters:
        ///   - event: The specific onboarding action that occurred.
        ///   - page: The page where the onboarding event took place.
        ///   - products: Products associated with the event.
        case onboarding(event: Onboarding, pageId: Page, productIds: [String])

        /// Represents an event related to a picker, such as selecting or
        /// uploading a photo.
        ///
        /// - Parameters:
        ///   - event: The specific picker action that occurred.
        ///   - page: The page where the picker event took place.
        ///   - products: Products associated with the event.
        case picker(event: Picker, pageId: Page, productIds: [String])

        /// Represents an event related to a try-on session, such as starting
        /// or finishing the session.
        ///
        /// - Parameters:
        ///   - event: The specific try-on action that occurred.
        ///   - page: The page where the try-on event took place.
        ///   - products: Products associated with the event.
        case tryOn(event: TryOn, pageId: Page, productIds: [String])

        /// Represents an event related to results, such as sharing a result or
        /// adding a product to a wishlist.
        ///
        /// - Parameters:
        ///   - event: The specific results action that occurred.
        ///   - page: The page where the results event took place.
        ///   - products: Products associated with the event.
        case results(event: Results, pageId: Page, productIds: [String])

        /// Represents an event related to feedback, such as submitting
        /// positive or negative feedback.
        ///
        /// - Parameters:
        ///   - event: The specific feedback action that occurred.
        ///   - page: The page where the feedback event took place.
        ///   - products: Products associated with the event.
        case feedback(event: Feedback, pageId: Page, productIds: [String])

        /// Represents an event related to history, such as sharing or deleting
        /// a generated image.
        ///
        /// - Parameters:
        ///   - event: The specific history action that occurred.
        ///   - page: The page where the history event took place.
        ///   - products: Products associated with the event.
        case history(event: History, pageId: Page, productIds: [String])

        /// Represents an event related to sharing, such as sharing a generated
        /// image or taking a screenshot.
        ///
        /// - Parameters:
        ///  - event: The specific share action that occurred.
        ///  - page: The page where the share event took place.
        ///  - products: Products associated with the event.
        case share(event: Share, pageId: Page, productIds: [String])

        /// Represents an event related to exiting the SDK, such as leaving a
        /// specific page.
        ///
        /// - Parameters:
        ///   - page: The page from which the user exited.
        ///   - products: Products associated with the event.
        case exit(pageId: Page, productIds: [String])
    }
}

extension Aiuta.Event {
    /// Represents the different pages in the SDK where events can occur.
    public enum Page: String, Sendable {
        /// The welcome page.
        case welcome

        /// The "How It Works" onboarding page.
        case howItWorks

        /// The "Best Results" onboarding page.
        case bestResults

        /// The consent page when in standalone mode.
        case consent

        /// The image picker page.
        case imagePicker

        /// The loading page.
        case loading

        /// The results page.
        case results

        /// The generations history page.
        case history
    }
}

extension Aiuta.Event {
    /// Represents the different flows in the SDK, such as try-on or history.
    public enum Flow: String, Sendable {
        /// Starting the SDK with tryOn flow to upload photo and generate results
        case tryOn

        /// Starting the SDK to show previously generated gallery
        case history
    }
}

extension Aiuta.Event {
    /// Represents onboarding-related actions, such as starting or completing
    /// onboarding.
    public enum Onboarding: Sendable {
        /// The user clicked to start the welcome process.
        case welcomeStartClicked

        /// The onboarding process was completed.
        case onboardingFinished

        /// The user provided consents.
        case consentsGiven(consentIds: [String])
    }
}

extension Aiuta.Event {
    /// Represents picker-related actions, such as opening the camera or
    /// selecting a photo.
    public enum Picker: String, Sendable {
        /// The camera was opened.
        case cameraOpened

        /// A new photo was taken with the camera.
        case newPhotoTaken

        /// The system photo gallery was opened.
        case photoGalleryOpened

        /// A photo was selected from the system photo gallery.
        case galleryPhotoSelected

        /// The uploads history was opened.
        case uploadsHistoryOpened

        /// A previously uploaded photo was selected.
        case uploadedPhotoSelected

        /// A previously uploaded photo was deleted.
        case uploadedPhotoDeleted

        /// The predefined models list was opened.
        case predefinedModelsOpened

        /// A predefined model was selected.
        case predefinedModelSelected
    }
}

extension Aiuta.Event {
    /// Represents try-on-related actions, such as uploading a photo or
    /// starting a session.
    public enum TryOn: Sendable {
        /// Start processing photo
        case initiated(origin: Origin)

        /// A photo was uploaded for try-on.
        case photoUploaded

        /// A try-on session was started.
        case tryOnStarted(origin: Origin)

        /// A try-on session was completed.
        ///
        /// - Parameters:
        ///  - uploadDuration: The duration of the photo upload.
        ///  - tryOnDuration: The duration of the try-on generation.
        ///  - downloadDuration: The duration of the result download.
        ///  - totalDuration: The total duration of the try-on session.
        case tryOnFinished(
            uploadDuration: TimeInterval,
            tryOnDuration: TimeInterval,
            downloadDuration: TimeInterval,
            totalDuration: TimeInterval
        )

        /// Cancellation of the try-on process before completion
        case tryOnAborted(reason: AbortReason)

        /// An error occurred during a try-on session.
        ///
        /// - Parameters:
        ///  - type: The type of error that occurred.
        ///  - message: An optional error message providing additional context.
        ///
        /// - Note: errorMessage contains information for developers and is not for users
        case tryOnError(type: ErrorType, message: String?)
    }
}

extension Aiuta.Event.TryOn {
    /// Represents the origin of the try-on initiated, indicating where it was
    /// initiated from, such as a selected photo or a button press.
    public enum Origin: String, Sendable {
        /// The try-on was initiated from a new photo chosen by the user,
        /// such as from the camera or photo gallery.
        case selectedPhoto

        /// The try-on was initiated from a "Try on" button press,
        /// when previously selected photo was already set.
        case tryOnButton

        /// The try-on was initiated from a "Continue with other photo"
        /// button press, when the user decided to retake the photo.
        case retakeButton

        /// The try-on was initiated from a "Try again" button press,
        /// when try-on generation was failed and user decided to try again
        /// with the same photo.
        case retryNotification

        /// Unknown origin of the try-on initiation.
        /// This can happen if the origin is not specified or recognized.
        case unknown
    }
}

extension Aiuta.Event.TryOn {
    /// Represents errors that occurred during the try-on session.
    public enum ErrorType: String, Sendable {
        /// Any reason users' photo cannot be processed by the SDK,
        /// that is not related to the try-on generation process on the server.
        /// This covers failure to read, downscale, compress and get JPG data
        /// of the photo.
        case preparePhotoFailed

        /// Any reason users' photo cannot be uploaded to the server.
        /// This may be caused by network issues, server issues, or any other reason.
        case uploadPhotoFailed

        /// The request to the server was not authorized.
        case authorizationFailed

        /// SDK failed to make a request to the server to start the try-on process.
        /// This may be caused by network issues, server issues, or any other reason.
        case requestOperationFailed

        /// SDK successfully made a request to the server to start the try-on process,
        /// but the server returned an error.
        case startOperationFailed

        /// SDK successfully made a request to the server to start the try-on process,
        /// operation was started, but the server returned an error while processing
        /// the operation, and it was failed. SDK stopped waiting for the result.
        case operationFailed

        /// SDK successfully made a request to the server to start the try-on process,
        /// operation was started, but the status of the operation was not changed
        /// for a long time, and the SDK stopped waiting for the result.
        case operationTimeout

        /// Try-on operation was completed, but the empty result was returned.
        case operationEmptyResults

        /// Try-on operation was completed, but the result was not downloaded.
        /// This may be caused by network issues, server issues, or any other reason.
        case downloadResultFailed

        /// Unexpected error occurred during the try-on process.
        /// Those should be reported to the SDK developers, as it is not
        /// supposed to happen.
        case internalSdkError
    }
}

extension Aiuta.Event.TryOn {
    /// Represents reasons of cancellation of the try-on process before completion
    public enum AbortReason: String, Sendable {
        /// SDK successfully made a request to the server to start the try-on process,
        /// operation was started, but the server aborted the operation,
        /// because of the invalid user input photo.
        case operationAborted

        /// Operation was in progress, but user closes the SDK
        /// and background execution was disabled
        case userCancelled
    }
}

extension Aiuta.Event {
    /// Represents results-related actions, such as sharing a result or adding
    /// a product to a cart.
    public enum Results: String, Sendable {
        /// A product was added to the wishlist.
        case productAddToWishlist

        /// A product was added to the cart.
        case productAddToCart

        /// The user chose to pick another photo.
        case pickOtherPhoto
    }
}

extension Aiuta.Event {
    /// Represents feedback-related actions, such as submitting positive or
    /// negative feedback.
    public enum Feedback: Sendable {
        /// Positive feedback was submitted.
        case positive

        /// Negative feedback was submitted, optionally with a specific option and text.
        ///
        /// - Parameters:
        ///  - option: The feedback option index.
        ///  - text: An optional string providing feedback text.
        case negative(option: Int, text: String?)
    }
}

extension Aiuta.Event {
    /// Represents history-related actions, such as sharing or deleting a
    /// generated image.
    public enum History: String, Sendable {
        /// A generated image was deleted.
        case generatedImageDeleted
    }
}

extension Aiuta.Event {
    /// Events related to the user's desire to share/save generated images
    public enum Share: Sendable {
        /// The user clicked the share button, a system dialog will be displayed
        case initiated

        /// The images were successfully shared to the 3rd party application
        case succeeded(targetId: String?)

        /// The user canceled the share process
        case canceled(targetId: String?)

        /// A system error occurred while sharing images
        case failed(targetId: String?)

        /// The user took a screenshot of the SDK page
        case screenshot
    }
}
