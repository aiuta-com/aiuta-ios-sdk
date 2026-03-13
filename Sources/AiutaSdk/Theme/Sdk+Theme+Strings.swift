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

#if SWIFT_PACKAGE
import AiutaConfig
import AiutaCore
@_spi(Aiuta) import AiutaKit
#endif
import UIKit

extension Sdk.Theme {
    struct Strings {
        let config: Aiuta.Configuration
        private var features: Aiuta.Configuration.Features { config.features }
        private var theme: Aiuta.Configuration.UserInterface.Theme { config.userInterface.theme }

        // MARK: - Welcome Screen

        var welcomeTitle: String? { features.welcomeScreen?.strings.welcomeTitle }
        var welcomeDescription: String? { features.welcomeScreen?.strings.welcomeDescription }
        var welcomeButtonStart: String? { features.welcomeScreen?.strings.welcomeButtonStart }

        // MARK: - Onboarding

        var onboardingButtonNext: String? { features.onboarding?.strings.onboardingButtonNext }
        var onboardingButtonStart: String? { features.onboarding?.strings.onboardingButtonStart }

        // MARK: - Onboarding.HowItWorks

        var onboardingHowItWorksPageTitle: String? { features.onboarding?.howItWorks.strings.onboardingHowItWorksPageTitle }
        var onboardingHowItWorksTitle: String? { features.onboarding?.howItWorks.strings.onboardingHowItWorksTitle }
        var onboardingHowItWorksDescription: String? { features.onboarding?.howItWorks.strings.onboardingHowItWorksDescription }

        // MARK: - Onboarding.BestResults

        var onboardingBestResultsPageTitle: String? { features.onboarding?.bestResults?.strings.onboardingBestResultsPageTitle }
        var onboardingBestResultsTitle: String? { features.onboarding?.bestResults?.strings.onboardingBestResultsTitle }
        var onboardingBestResultsDescription: String? { features.onboarding?.bestResults?.strings.onboardingBestResultsDescription }

        // MARK: - Consent.Embedded

        var consentHtml: String? {
            if case let .embeddedIntoOnboarding(embedded) = features.consent {
                return embedded.strings.consentHtml
            }
            return nil
        }

        // MARK: - Consent.Standalone

        var consentPageTitle: String? { features.consent.standalone?.strings.consentPageTitle }
        var consentTitle: String? { features.consent.standalone?.strings.consentTitle }
        var consentDescriptionHtml: String? { features.consent.standalone?.strings.consentDescriptionHtml }
        var consentFooterHtml: String? { features.consent.standalone?.strings.consentFooterHtml }
        var consentButtonAccept: String? { features.consent.standalone?.strings.consentButtonAccept }

        // MARK: - ImagePicker

        var imagePickerTitle: String { features.imagePicker.strings.imagePickerTitle }
        var imagePickerDescription: String { features.imagePicker.strings.imagePickerDescription }
        var imagePickerButtonUploadPhoto: String { features.imagePicker.strings.imagePickerButtonUploadPhoto }

        // MARK: - ImagePicker.Camera

        var cameraButtonTakePhoto: String? { features.imagePicker.camera?.strings.cameraButtonTakePhoto }
        var cameraPermissionTitle: String? { features.imagePicker.camera?.strings.cameraPermissionTitle }
        var cameraPermissionDescription: String? { features.imagePicker.camera?.strings.cameraPermissionDescription }
        var cameraPermissionButtonOpenSettings: String? { features.imagePicker.camera?.strings.cameraPermissionButtonOpenSettings }

        // MARK: - ImagePicker.Gallery

        var galleryButtonSelectPhoto: String { features.imagePicker.photoGallery.strings.galleryButtonSelectPhoto }

        // MARK: - ImagePicker.PredefinedModel

        var predefinedModelsTitle: String? { features.imagePicker.predefinedModels?.strings.predefinedModelsTitle }
        var predefinedModelsOr: String? { features.imagePicker.predefinedModels?.strings.predefinedModelsOr }
        var predefinedModelsEmptyListError: String? { features.imagePicker.predefinedModels?.strings.predefinedModelsEmptyListError }
        var predefinedModelsCategories: [String: String] { features.imagePicker.predefinedModels?.strings.predefinedModelsCategories ?? [:] }

        // MARK: - ImagePicker.UploadsHistory

        var uploadsHistoryButtonNewPhoto: String? { features.imagePicker.uploadsHistory?.strings.uploadsHistoryButtonNewPhoto }
        var uploadsHistoryTitle: String? { features.imagePicker.uploadsHistory?.strings.uploadsHistoryTitle }
        var uploadsHistoryButtonChangePhoto: String? { features.imagePicker.uploadsHistory?.strings.uploadsHistoryButtonChangePhoto }

        // MARK: - ImagePicker.ProtectionDisclaimer

        var protectionDisclaimer: String? { features.imagePicker.protectionDisclaimer?.strings.protectionDisclaimer }

        // MARK: - TryOn

        var tryOnPageTitle: String { features.tryOn.strings.tryOnPageTitle }
        var tryOn: String { features.tryOn.strings.tryOn }
        var outfitTitle: String { features.tryOn.strings.outfitTitle }

        // MARK: - TryOn.Loading

        var tryOnLoadingStatusUploadingImage: String { features.tryOn.loadingPage.strings.tryOnLoadingStatusUploadingImage }
        var tryOnLoadingStatusScanningBody: String { features.tryOn.loadingPage.strings.tryOnLoadingStatusScanningBody }
        var tryOnLoadingStatusGeneratingOutfit: String { features.tryOn.loadingPage.strings.tryOnLoadingStatusGeneratingOutfit }

        // MARK: - TryOn.InputValidation

        var invalidInputImageDescription: String { features.tryOn.inputImageValidation.strings.invalidInputImageDescription }
        var invalidInputImageChangePhotoButton: String { features.tryOn.inputImageValidation.strings.invalidInputImageChangePhotoButton }

        // MARK: - TryOn.Cart

        var addToCart: String? { features.tryOn.cart?.strings.addToCart }
        var shopTheLook: String? { features.tryOn.cart?.outfit?.strings.addToCartOutfit }

        // MARK: - TryOn.FitDisclaimer

        var fitDisclaimerTitle: String? { features.tryOn.fitDisclaimer?.strings.fitDisclaimerTitle }
        var fitDisclaimerDescription: String? { features.tryOn.fitDisclaimer?.strings.fitDisclaimerDescription }
        var fitDisclaimerCloseButton: String? { features.tryOn.fitDisclaimer?.strings.fitDisclaimerCloseButton }

        // MARK: - TryOn.Feedback

        var feedbackTitle: String? { features.tryOn.feedback?.strings.feedbackTitle }
        var feedbackOptions: [String] { features.tryOn.feedback?.strings.feedbackOptions ?? [] }
        var feedbackButtonSkip: String? { features.tryOn.feedback?.strings.feedbackButtonSkip }
        var feedbackButtonSend: String? { features.tryOn.feedback?.strings.feedbackButtonSend }
        var feedbackGratitudeText: String? { features.tryOn.feedback?.strings.feedbackGratitudeText }

        // MARK: - TryOn.Feedback.Other

        var feedbackOptionOther: String? { features.tryOn.feedback?.other?.strings.feedbackOptionOther }
        var otherFeedbackTitle: String? { features.tryOn.feedback?.other?.strings.otherFeedbackTitle }
        var otherFeedbackButtonSend: String? { features.tryOn.feedback?.other?.strings.otherFeedbackButtonSend }
        var otherFeedbackButtonCancel: String? { features.tryOn.feedback?.other?.strings.otherFeedbackButtonCancel }

        // MARK: - TryOn.History

        var generationsHistoryPageTitle: String? { features.tryOn.generationsHistory?.strings.generationsHistoryPageTitle }

        // MARK: - Share

        var shareButton: String? { features.share?.strings.shareButton }

        // MARK: - Wishlist

        var wishlistButtonAdd: String? { features.wishlist?.strings.wishlistButtonAdd }

        // MARK: - Selection

        var select: String { theme.selectionSnackbar.strings.select }
        var cancel: String { theme.selectionSnackbar.strings.cancel }
        var selectAll: String { theme.selectionSnackbar.strings.selectAll }
        var unselectAll: String { theme.selectionSnackbar.strings.unselectAll }

        // MARK: - Error

        var defaultErrorMessage: String { theme.errorSnackbar.strings.defaultErrorMessage }
        var tryAgainButton: String { theme.errorSnackbar.strings.tryAgainButton }

        // MARK: - PowerBar

        var poweredByAiuta: String { theme.powerBar.strings.poweredByAiuta }
    }
}
