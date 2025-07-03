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
import UIKit

extension Sdk.Configuration {
    struct Strings {
        // MARK: - Welcome Screen

        var welcomeTitle: String?
        var welcomeDescription: String?
        var welcomeButtonStart: String?

        // MARK: - Onboarding

        var onboardingButtonNext: String = "Next"
        var onboardingButtonStart: String = "Start"

        // MARK: - Onboarding.HowItWorks

        var onboardingHowItWorksPageTitle: String?
        var onboardingHowItWorksTitle: String = "Try on before buying"
        var onboardingHowItWorksDescription: String = "Upload a photo and see how items look on you"

        // MARK: - Onboarding.BestResults

        var onboardingBestResultsPageTitle: String?
        var onboardingBestResultsTitle: String?
        var onboardingBestResultsDescription: String?

        // MARK: - Conset.Embedded

        var consentHtml: String = "Your photos will be processed by \(Html("Terms of Use", .bold, .link("https://aiuta.com/legal/terms-of-service.html")))"

        // MARK: - Conset.Standalone

        var consentPageTitle: String?
        var consentTitle: String?
        var consentDescriptionHtml: String?
        var consentFooterHtml: String?
        var consentButtonAccept: String?
        var consentButtonReject: String?

        // MARK: - ImagePicker

        var imagePickerTitle: String = "Upload a photo of you"
        var imagePickerDescription: String = "Select a photo where you are standing straight and clearly visible"
        var imagePickerButtonUploadPhoto: String = "Upload a photo"

        // MARK: - ImagePicker.Camera

        var cameraButtonTakePhoto: String = "Take a photo"
        var cameraPermissionTitle: String = "Camera permission"
        var cameraPermissionDescription: String = "Please allow access to the camera in the application settings"
        var cameraPermissionButtonOpenSettings: String = "Settings"

        // MARK: - ImagePicker.Gallery

        var galleryButtonSelectPhoto: String = "Choose from library"

        // MARK: - ImagePicker.PredefinedModel

        var predefinedModelsTitle: String = "Select your model"
        var predefinedModelsOr: String = "Or"
        var predefinedModelsEmptyListError: String = "The models list is empty"
        var predefinedModelsCategories: [String: String] = ["man": "Men", "woman": "Women"]

        // MARK: - ImagePicker.UploadsHistory

        var uploadsHistoryButtonNewPhoto: String = "+ New photo or model"
        var uploadsHistoryTitle: String = "Previously used"
        var uploadsHistoryButtonChangePhoto: String = "Change photo"

        // MARK: - TryOn

        var tryOnPageTitle: String = "Virtual Try-on"
        var tryOn: String = "Try on"

        // MARK: - TryOn.Loading

        var tryOnLoadingStatusUploadingImage: String = "Uploading image"
        var tryOnLoadingStatusScanningBody: String = "Scanning the body"
        var tryOnLoadingStatusGeneratingOutfit: String = "Generating outfit"

        // MARK: - TryOn.InputValidation

        var invalidInputImageDescription: String = "We couldn’t detect\nanyone in this photo"
        var invalidInputImageChangePhotoButton: String = "Change photo"

        // MARK: - TryOn.Cart

        var addToCart: String = "Add to cart"

        // MARK: - TryOn.FitDisclaimer

        var fitDisclaimerTitle: String = "Results may vary from real-life fit"
        var fitDisclaimerDescription: String = "Virtual try-on is a visualization tool that shows how items might look and may not perfectly represent how the item will fit in reality"
        var fitDisclaimerCloseButton: String = "Close"

        // MARK: - TryOn.Feedback

        var feedbackTitle: String = "Can you tell us more?"
        var feedbackOptions: [String] = ["This style isn’t for me", "The item looks off", "I look different"]
        var feedbackButtonSkip: String = "Skip"
        var feedbackButtonSend: String = "Send"
        var feedbackGratitudeText: String = "Thank you for your feedback"

        // MARK: - TryOn.Feedback.Other

        var feedbackOptionOther: String = "Other"
        var otherFeedbackTitle: String = "Tell us what we could improve?"
        var otherFeedbackButtonSend: String = "Send feedback"
        var otherFeedbackButtonCancel: String = "Cancel"

        // MARK: - TryOn.History

        var generationsHistoryPageTitle: String = "History"

        // MARK: - Share

        var shareButton: String = "Share"

        // MARK: - Wishlist

        var wishlistButtonAdd: String = "Wishlist"

        // MARK: - Selection

        var select: String = "Select"
        var cancel: String = "Cancel"
        var selectAll: String = "Select all"
        var unselectAll: String = "Unselect all"

        // MARK: - Error

        var defaultErrorMessage: String = "Something went wrong.\nPlease try again later"
        var tryAgainButton: String = "Try again"

        // MARK: - PowerBar

        var poweredByAiuta: String = "Powered by Aiuta"
    }
}
