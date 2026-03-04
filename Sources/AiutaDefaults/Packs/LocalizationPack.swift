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

public struct LocalizationPack: Sendable {
    // Onboarding
    public let onboardingButtonNext: String
    public let onboardingButtonStart: String
    public let onboardingHowItWorksTitle: String
    public let onboardingHowItWorksDescription: String
    // ImagePicker
    public let imagePickerTitle: String
    public let imagePickerDescription: String
    public let imagePickerButtonUploadPhoto: String
    // Camera
    public let cameraButtonTakePhoto: String
    public let cameraPermissionTitle: String
    public let cameraPermissionDescription: String
    public let cameraPermissionButtonOpenSettings: String
    // Gallery
    public let galleryButtonSelectPhoto: String
    // PredefinedModels
    public let predefinedModelsTitle: String
    public let predefinedModelsOr: String
    public let predefinedModelsEmptyListError: String
    public let predefinedModelsCategories: [String: String]
    // UploadsHistory
    public let uploadsHistoryButtonNewPhoto: String
    public let uploadsHistoryTitle: String
    public let uploadsHistoryButtonChangePhoto: String
    // Cart
    public let addToCart: String
    // TryOn
    public let tryOnPageTitle: String
    public let tryOn: String
    public let tryOnLoadingStatusUploadingImage: String
    public let tryOnLoadingStatusScanningBody: String
    public let tryOnLoadingStatusGeneratingOutfit: String
    // Validation
    public let invalidInputImageDescription: String
    public let invalidInputImageChangePhotoButton: String
    // FitDisclaimer
    public let fitDisclaimerTitle: String
    public let fitDisclaimerDescription: String
    public let fitDisclaimerCloseButton: String
    // Feedback
    public let feedbackTitle: String
    public let feedbackOptions: [String]
    public let feedbackButtonSkip: String
    public let feedbackButtonSend: String
    public let feedbackGratitudeText: String
    public let feedbackOptionOther: String
    public let otherFeedbackTitle: String
    public let otherFeedbackButtonSend: String
    public let otherFeedbackButtonCancel: String
    // History
    public let generationsHistoryPageTitle: String
    // Share
    public let shareButton: String
    // Selection
    public let select: String
    public let cancel: String
    public let selectAll: String
    public let unselectAll: String
    // Error
    public let defaultErrorMessage: String
    public let tryAgainButton: String
    // PowerBar
    public let poweredByAiuta: String
    // Consent
    public let consentHtml: String

    // swiftlint:disable function_body_length
    public init(onboardingButtonNext: String = "Next",
                onboardingButtonStart: String = "Start",
                onboardingHowItWorksTitle: String = "Try on before buying",
                onboardingHowItWorksDescription: String = "Upload a photo and see how items look on you",
                imagePickerTitle: String = "Upload a photo of you",
                imagePickerDescription: String = "Select a photo where you are standing straight and clearly visible",
                imagePickerButtonUploadPhoto: String = "Upload a photo",
                cameraButtonTakePhoto: String = "Take a photo",
                cameraPermissionTitle: String = "Camera permission",
                cameraPermissionDescription: String = "Please allow access to the camera in the application settings",
                cameraPermissionButtonOpenSettings: String = "Settings",
                galleryButtonSelectPhoto: String = "Choose from library",
                predefinedModelsTitle: String = "Select your model",
                predefinedModelsOr: String = "Or",
                predefinedModelsEmptyListError: String = "The models list is empty",
                predefinedModelsCategories: [String: String] = ["man": "Men", "woman": "Women"],
                uploadsHistoryButtonNewPhoto: String = "+ New photo or model",
                uploadsHistoryTitle: String = "Previously used",
                uploadsHistoryButtonChangePhoto: String = "Change photo",
                addToCart: String = "Add to cart",
                tryOnPageTitle: String = "Virtual Try-on",
                tryOn: String = "Try on",
                tryOnLoadingStatusUploadingImage: String = "Uploading image",
                tryOnLoadingStatusScanningBody: String = "Scanning the body",
                tryOnLoadingStatusGeneratingOutfit: String = "Generating outfit",
                invalidInputImageDescription: String = "We couldn't detect\nanyone in this photo",
                invalidInputImageChangePhotoButton: String = "Change photo",
                fitDisclaimerTitle: String = "Results may vary from real-life fit",
                fitDisclaimerDescription: String = "Virtual try-on is a visualization tool that shows how items might look and may not perfectly represent how the item will fit in reality",
                fitDisclaimerCloseButton: String = "Close",
                feedbackTitle: String = "Can you tell us more?",
                feedbackOptions: [String] = ["This style isn't for me", "The item looks off", "I look different"],
                feedbackButtonSkip: String = "Skip",
                feedbackButtonSend: String = "Send",
                feedbackGratitudeText: String = "Thank you for your feedback",
                feedbackOptionOther: String = "Other",
                otherFeedbackTitle: String = "Tell us what we could improve?",
                otherFeedbackButtonSend: String = "Send feedback",
                otherFeedbackButtonCancel: String = "Cancel",
                generationsHistoryPageTitle: String = "History",
                shareButton: String = "Share",
                select: String = "Select",
                cancel: String = "Cancel",
                selectAll: String = "Select all",
                unselectAll: String = "Unselect all",
                defaultErrorMessage: String = "Something went wrong.\nPlease try again later",
                tryAgainButton: String = "Try again",
                poweredByAiuta: String = "Powered by Aiuta",
                consentHtml: String = "Your photos will be processed by <b><a href=\"https://aiuta.com/legal/terms-of-service.html\">Terms of Use</a></b>") {
        self.onboardingButtonNext = onboardingButtonNext
        self.onboardingButtonStart = onboardingButtonStart
        self.onboardingHowItWorksTitle = onboardingHowItWorksTitle
        self.onboardingHowItWorksDescription = onboardingHowItWorksDescription
        self.imagePickerTitle = imagePickerTitle
        self.imagePickerDescription = imagePickerDescription
        self.imagePickerButtonUploadPhoto = imagePickerButtonUploadPhoto
        self.cameraButtonTakePhoto = cameraButtonTakePhoto
        self.cameraPermissionTitle = cameraPermissionTitle
        self.cameraPermissionDescription = cameraPermissionDescription
        self.cameraPermissionButtonOpenSettings = cameraPermissionButtonOpenSettings
        self.galleryButtonSelectPhoto = galleryButtonSelectPhoto
        self.predefinedModelsTitle = predefinedModelsTitle
        self.predefinedModelsOr = predefinedModelsOr
        self.predefinedModelsEmptyListError = predefinedModelsEmptyListError
        self.predefinedModelsCategories = predefinedModelsCategories
        self.uploadsHistoryButtonNewPhoto = uploadsHistoryButtonNewPhoto
        self.uploadsHistoryTitle = uploadsHistoryTitle
        self.uploadsHistoryButtonChangePhoto = uploadsHistoryButtonChangePhoto
        self.addToCart = addToCart
        self.tryOnPageTitle = tryOnPageTitle
        self.tryOn = tryOn
        self.tryOnLoadingStatusUploadingImage = tryOnLoadingStatusUploadingImage
        self.tryOnLoadingStatusScanningBody = tryOnLoadingStatusScanningBody
        self.tryOnLoadingStatusGeneratingOutfit = tryOnLoadingStatusGeneratingOutfit
        self.invalidInputImageDescription = invalidInputImageDescription
        self.invalidInputImageChangePhotoButton = invalidInputImageChangePhotoButton
        self.fitDisclaimerTitle = fitDisclaimerTitle
        self.fitDisclaimerDescription = fitDisclaimerDescription
        self.fitDisclaimerCloseButton = fitDisclaimerCloseButton
        self.feedbackTitle = feedbackTitle
        self.feedbackOptions = feedbackOptions
        self.feedbackButtonSkip = feedbackButtonSkip
        self.feedbackButtonSend = feedbackButtonSend
        self.feedbackGratitudeText = feedbackGratitudeText
        self.feedbackOptionOther = feedbackOptionOther
        self.otherFeedbackTitle = otherFeedbackTitle
        self.otherFeedbackButtonSend = otherFeedbackButtonSend
        self.otherFeedbackButtonCancel = otherFeedbackButtonCancel
        self.generationsHistoryPageTitle = generationsHistoryPageTitle
        self.shareButton = shareButton
        self.select = select
        self.cancel = cancel
        self.selectAll = selectAll
        self.unselectAll = unselectAll
        self.defaultErrorMessage = defaultErrorMessage
        self.tryAgainButton = tryAgainButton
        self.poweredByAiuta = poweredByAiuta
        self.consentHtml = consentHtml
    }
    // swiftlint:enable function_body_length
}
