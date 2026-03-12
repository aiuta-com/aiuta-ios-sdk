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

extension Sdk {
    final class Validator {
        private static var fatalErrorCount = 0

        static func validate(_ configuration: Aiuta.Configuration) {
            let debug = configuration.debugSettings
            fatalErrorCount = 0

            validateEmptyStrings(configuration, policy: debug.emptyStringsPolicy)
            validateListSizes(configuration, policy: debug.listSizePolicy)
            validateInfoPlist(configuration, policy: debug.infoPlistDescriptionsPolicy)

            if fatalErrorCount > 0 {
                fatalError("Aiuta SDK Validation: \(fatalErrorCount) error(s) found. See warnings above for details.")
            }
        }

        // MARK: - Empty Strings Validation

        private static func validateEmptyStrings(_ configuration: Aiuta.Configuration,
                                                 policy: Aiuta.Configuration.ValidationPolicy) {
            guard !policy.isIgnored else { return }
            let features = configuration.features
            let theme = configuration.userInterface.theme

            // Auth
            switch configuration.auth {
                case let .apiKey(apiKey):
                    validate(string: apiKey, name: "auth.apiKey", policy: policy)
                case let .jwt(subscriptionId, _):
                    validate(string: subscriptionId, name: "auth.subscriptionId", policy: policy)
            }

            // TryOn
            let tryOn = features.tryOn
            validate(string: tryOn.strings.tryOnPageTitle, name: "tryOn.strings.tryOnPageTitle", policy: policy)
            validate(string: tryOn.strings.tryOn, name: "tryOn.strings.tryOn", policy: policy)

            // TryOn - Loading Page
            let loading = tryOn.loadingPage.strings
            validate(string: loading.tryOnLoadingStatusUploadingImage, name: "tryOn.loadingPage.strings.tryOnLoadingStatusUploadingImage", policy: policy)
            validate(string: loading.tryOnLoadingStatusScanningBody, name: "tryOn.loadingPage.strings.tryOnLoadingStatusScanningBody", policy: policy)
            validate(string: loading.tryOnLoadingStatusGeneratingOutfit, name: "tryOn.loadingPage.strings.tryOnLoadingStatusGeneratingOutfit", policy: policy)

            // TryOn - Input Validation
            let inputValidation = tryOn.inputImageValidation.strings
            validate(string: inputValidation.invalidInputImageDescription, name: "tryOn.inputImageValidation.strings.invalidInputImageDescription", policy: policy)
            validate(string: inputValidation.invalidInputImageChangePhotoButton, name: "tryOn.inputImageValidation.strings.invalidInputImageChangePhotoButton", policy: policy)

            // TryOn - Cart
            if let cart = tryOn.cart {
                validate(string: cart.strings.addToCart, name: "tryOn.cart.strings.addToCart", policy: policy)
                if let outfit = cart.outfit {
                    validate(string: outfit.strings.addToCartOutfit, name: "tryOn.cart.outfit.strings.addToCartOutfit", policy: policy)
                }
            }

            // TryOn - Fit Disclaimer
            if let fitDisclaimer = tryOn.fitDisclaimer {
                validate(string: fitDisclaimer.strings.fitDisclaimerTitle, name: "tryOn.fitDisclaimer.strings.fitDisclaimerTitle", policy: policy)
                validate(string: fitDisclaimer.strings.fitDisclaimerDescription, name: "tryOn.fitDisclaimer.strings.fitDisclaimerDescription", policy: policy)
                validate(string: fitDisclaimer.strings.fitDisclaimerCloseButton, name: "tryOn.fitDisclaimer.strings.fitDisclaimerCloseButton", policy: policy)
            }

            // TryOn - Feedback
            if let feedback = tryOn.feedback {
                validate(string: feedback.strings.feedbackTitle, name: "tryOn.feedback.strings.feedbackTitle", policy: policy)
                validate(string: feedback.strings.feedbackButtonSkip, name: "tryOn.feedback.strings.feedbackButtonSkip", policy: policy)
                validate(string: feedback.strings.feedbackButtonSend, name: "tryOn.feedback.strings.feedbackButtonSend", policy: policy)
                validate(string: feedback.strings.feedbackGratitudeText, name: "tryOn.feedback.strings.feedbackGratitudeText", policy: policy)
                for (index, option) in feedback.strings.feedbackOptions.enumerated() {
                    validate(string: option, name: "tryOn.feedback.strings.feedbackOptions[\(index)]", policy: policy)
                }
                if let other = feedback.other {
                    validate(string: other.strings.feedbackOptionOther, name: "tryOn.feedback.other.strings.feedbackOptionOther", policy: policy)
                    validate(string: other.strings.otherFeedbackTitle, name: "tryOn.feedback.other.strings.otherFeedbackTitle", policy: policy)
                    validate(string: other.strings.otherFeedbackButtonSend, name: "tryOn.feedback.other.strings.otherFeedbackButtonSend", policy: policy)
                    validate(string: other.strings.otherFeedbackButtonCancel, name: "tryOn.feedback.other.strings.otherFeedbackButtonCancel", policy: policy)
                }
            }

            // TryOn - Generations History
            if let history = tryOn.generationsHistory {
                validate(string: history.strings.generationsHistoryPageTitle, name: "tryOn.generationsHistory.strings.generationsHistoryPageTitle", policy: policy)
            }

            // Image Picker
            let imagePicker = features.imagePicker
            validate(string: imagePicker.strings.imagePickerTitle, name: "imagePicker.strings.imagePickerTitle", policy: policy)
            validate(string: imagePicker.strings.imagePickerDescription, name: "imagePicker.strings.imagePickerDescription", policy: policy)
            validate(string: imagePicker.strings.imagePickerButtonUploadPhoto, name: "imagePicker.strings.imagePickerButtonUploadPhoto", policy: policy)

            // Image Picker - Camera
            if let camera = imagePicker.camera {
                validate(string: camera.strings.cameraButtonTakePhoto, name: "imagePicker.camera.strings.cameraButtonTakePhoto", policy: policy)
                validate(string: camera.strings.cameraPermissionTitle, name: "imagePicker.camera.strings.cameraPermissionTitle", policy: policy)
                validate(string: camera.strings.cameraPermissionDescription, name: "imagePicker.camera.strings.cameraPermissionDescription", policy: policy)
                validate(string: camera.strings.cameraPermissionButtonOpenSettings, name: "imagePicker.camera.strings.cameraPermissionButtonOpenSettings", policy: policy)
            }

            // Image Picker - Gallery
            validate(string: imagePicker.photoGallery.strings.galleryButtonSelectPhoto, name: "imagePicker.photoGallery.strings.galleryButtonSelectPhoto", policy: policy)

            // Image Picker - Predefined Models
            if let models = imagePicker.predefinedModels {
                validate(string: models.strings.predefinedModelsTitle, name: "imagePicker.predefinedModels.strings.predefinedModelsTitle", policy: policy)
                validate(string: models.strings.predefinedModelsOr, name: "imagePicker.predefinedModels.strings.predefinedModelsOr", policy: policy)
                validate(string: models.strings.predefinedModelsEmptyListError, name: "imagePicker.predefinedModels.strings.predefinedModelsEmptyListError", policy: policy)
            }

            // Image Picker - Protection Disclaimer
            if let disclaimer = imagePicker.protectionDisclaimer {
                validate(string: disclaimer.strings.protectionDisclaimer, name: "imagePicker.protectionDisclaimer.strings.protectionDisclaimer", policy: policy)
            }

            // Image Picker - Uploads History
            if let history = imagePicker.uploadsHistory {
                validate(string: history.strings.uploadsHistoryButtonNewPhoto, name: "imagePicker.uploadsHistory.strings.uploadsHistoryButtonNewPhoto", policy: policy)
                validate(string: history.strings.uploadsHistoryTitle, name: "imagePicker.uploadsHistory.strings.uploadsHistoryTitle", policy: policy)
                validate(string: history.strings.uploadsHistoryButtonChangePhoto, name: "imagePicker.uploadsHistory.strings.uploadsHistoryButtonChangePhoto", policy: policy)
            }

            // Consent
            switch features.consent {
                case .none:
                    break
                case let .embeddedIntoOnboarding(embedded):
                    validate(string: embedded.strings.consentHtml, name: "consent.embedded.strings.consentHtml", policy: policy)
                case let .standaloneOnboardingPage(standalone),
                     let .standaloneImagePickerPage(standalone):
                    validate(string: standalone.strings.consentTitle, name: "consent.standalone.strings.consentTitle", policy: policy)
                    validate(string: standalone.strings.consentDescriptionHtml, name: "consent.standalone.strings.consentDescriptionHtml", policy: policy)
                    validate(string: standalone.strings.consentButtonAccept, name: "consent.standalone.strings.consentButtonAccept", policy: policy)
                    validateConsents(standalone.data, policy: policy)
            }

            // Onboarding
            if let onboarding = features.onboarding {
                validate(string: onboarding.strings.onboardingButtonNext, name: "onboarding.strings.onboardingButtonNext", policy: policy)
                validate(string: onboarding.strings.onboardingButtonStart, name: "onboarding.strings.onboardingButtonStart", policy: policy)

                // How It Works
                validate(string: onboarding.howItWorks.strings.onboardingHowItWorksTitle, name: "onboarding.howItWorks.strings.onboardingHowItWorksTitle", policy: policy)
                validate(string: onboarding.howItWorks.strings.onboardingHowItWorksDescription, name: "onboarding.howItWorks.strings.onboardingHowItWorksDescription", policy: policy)

                // Best Results
                if let bestResults = onboarding.bestResults {
                    validate(string: bestResults.strings.onboardingBestResultsTitle, name: "onboarding.bestResults.strings.onboardingBestResultsTitle", policy: policy)
                    validate(string: bestResults.strings.onboardingBestResultsDescription, name: "onboarding.bestResults.strings.onboardingBestResultsDescription", policy: policy)
                }
            }

            // Welcome Screen
            if let welcome = features.welcomeScreen {
                validate(string: welcome.strings.welcomeTitle, name: "welcomeScreen.strings.welcomeTitle", policy: policy)
                validate(string: welcome.strings.welcomeDescription, name: "welcomeScreen.strings.welcomeDescription", policy: policy)
                validate(string: welcome.strings.welcomeButtonStart, name: "welcomeScreen.strings.welcomeButtonStart", policy: policy)
            }

            // Share
            if let share = features.share {
                validate(string: share.strings.shareButton, name: "share.strings.shareButton", policy: policy)
            }

            // Wishlist
            if let wishlist = features.wishlist {
                validate(string: wishlist.strings.wishlistButtonAdd, name: "wishlist.strings.wishlistButtonAdd", policy: policy)
            }

            // UI Theme Strings
            let error = theme.errorSnackbar.strings
            validate(string: error.defaultErrorMessage, name: "theme.errorSnackbar.strings.defaultErrorMessage", policy: policy)
            validate(string: error.tryAgainButton, name: "theme.errorSnackbar.strings.tryAgainButton", policy: policy)

            let selection = theme.selectionSnackbar.strings
            validate(string: selection.select, name: "theme.selectionSnackbar.strings.select", policy: policy)
            validate(string: selection.cancel, name: "theme.selectionSnackbar.strings.cancel", policy: policy)
            validate(string: selection.selectAll, name: "theme.selectionSnackbar.strings.selectAll", policy: policy)
            validate(string: selection.unselectAll, name: "theme.selectionSnackbar.strings.unselectAll", policy: policy)

            validate(string: theme.powerBar.strings.poweredByAiuta, name: "theme.powerBar.strings.poweredByAiuta", policy: policy)
        }

        private static func validateConsents(_ provider: Aiuta.Configuration.Features.Consent.Standalone.ConsentProvider,
                                             policy: Aiuta.Configuration.ValidationPolicy) {
            let consents: [Aiuta.Consent]
            switch provider {
                case let .userDefaults(list): consents = list
                case let .userDefaultsWithCallback(list, _): consents = list
                case let .dataProvider(list, _): consents = list
            }
            for consent in consents {
                validate(string: consent.id, name: "consent.standalone.consents.id", policy: policy)
                validate(string: consent.html, name: "consent.standalone.consents.html", policy: policy)
            }
        }

        // MARK: - List Size Validation

        private static func validateListSizes(_ configuration: Aiuta.Configuration,
                                              policy: Aiuta.Configuration.ValidationPolicy) {
            guard !policy.isIgnored else { return }
            let features = configuration.features

            // Image Picker - Examples (exactly 2)
            validate(
                list: features.imagePicker.images.imagePickerExamples,
                name: "imagePicker.images.imagePickerExamples",
                expectedCount: 2,
                policy: policy
            )

            // Onboarding
            if let onboarding = features.onboarding {
                // How It Works Items (exactly 3)
                validate(
                    list: onboarding.howItWorks.images.onboardingHowItWorksItems,
                    name: "onboarding.howItWorks.images.onboardingHowItWorksItems",
                    expectedCount: 3,
                    policy: policy
                )

                // Best Results (exactly 2 each)
                if let bestResults = onboarding.bestResults {
                    validate(
                        list: bestResults.images.onboardingBestResultsGood,
                        name: "onboarding.bestResults.images.onboardingBestResultsGood",
                        expectedCount: 2,
                        policy: policy
                    )
                    validate(
                        list: bestResults.images.onboardingBestResultsBad,
                        name: "onboarding.bestResults.images.onboardingBestResultsBad",
                        expectedCount: 2,
                        policy: policy
                    )
                }
            }

            // TryOn - Button Gradient (if provided, must not be empty)
            if let gradient = features.tryOn.styles.tryOnButtonGradient {
                validate(
                    listNotEmpty: gradient,
                    name: "tryOn.styles.tryOnButtonGradient",
                    policy: policy
                )
            }

            // TryOn - Feedback Options (not empty)
            if let feedback = features.tryOn.feedback {
                validate(
                    listNotEmpty: feedback.strings.feedbackOptions,
                    name: "tryOn.feedback.strings.feedbackOptions",
                    policy: policy
                )
            }

            // Predefined Models Categories (not empty)
            if let models = features.imagePicker.predefinedModels {
                validate(
                    listNotEmpty: Array(models.strings.predefinedModelsCategories.keys),
                    name: "imagePicker.predefinedModels.strings.predefinedModelsCategories",
                    policy: policy
                )
            }

            // Consent - Consents list (not empty for standalone)
            switch features.consent {
                case .none, .embeddedIntoOnboarding:
                    break
                case let .standaloneOnboardingPage(standalone),
                     let .standaloneImagePickerPage(standalone):
                    validateConsentsListSize(standalone.data, policy: policy)
            }
        }

        private static func validateConsentsListSize(_ provider: Aiuta.Configuration.Features.Consent.Standalone.ConsentProvider,
                                                     policy: Aiuta.Configuration.ValidationPolicy) {
            let consents: [Aiuta.Consent]
            switch provider {
                case let .userDefaults(list): consents = list
                case let .userDefaultsWithCallback(list, _): consents = list
                case let .dataProvider(list, _): consents = list
            }
            validate(
                listNotEmpty: consents,
                name: "consent.standalone.consents",
                policy: policy
            )
        }

        // MARK: - Info.plist Validation

        private static func validateInfoPlist(_ configuration: Aiuta.Configuration,
                                              policy: Aiuta.Configuration.ValidationPolicy) {
            guard !policy.isIgnored else { return }

            // Camera requires NSCameraUsageDescription
            if configuration.features.imagePicker.camera != nil {
                validate(
                    plistKey: "NSCameraUsageDescription",
                    reason: "Camera feature is enabled but NSCameraUsageDescription is missing from Info.plist",
                    policy: policy
                )
            }

            // Share requires NSPhotoLibraryAddUsageDescription for saving generated images
            // Never fatal — the app may still work, but saving will be not available in share activity
            if configuration.features.share != nil {
                validate(
                    plistKey: "NSPhotoLibraryAddUsageDescription",
                    reason: "Share feature is enabled but NSPhotoLibraryAddUsageDescription is missing from Info.plist",
                    policy: policy.clampedToWarning
                )
            }
        }

        // MARK: - Helpers

        private static func validate(string: String, name: String,
                                     policy: Aiuta.Configuration.ValidationPolicy) {
            guard string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
            report("Configuration string '\(name)' is empty", policy: policy)
        }

        private static func validate<T>(list: [T], name: String, expectedCount: Int,
                                        policy: Aiuta.Configuration.ValidationPolicy) {
            guard list.count != expectedCount else { return }
            report("Configuration list '\(name)' has \(list.count) items, expected exactly \(expectedCount)", policy: policy)
        }

        private static func validate<T>(listNotEmpty list: [T], name: String,
                                        policy: Aiuta.Configuration.ValidationPolicy) {
            guard list.isEmpty else { return }
            report("Configuration list '\(name)' is empty", policy: policy)
        }

        private static func validate(plistKey: String, reason: String,
                                     policy: Aiuta.Configuration.ValidationPolicy) {
            let value = Bundle.main.object(forInfoDictionaryKey: plistKey) as? String
            guard value == nil || value?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true else { return }
            report(reason, policy: policy)
        }

        private static func report(_ message: String,
                                   policy: Aiuta.Configuration.ValidationPolicy) {
            switch policy {
                case .ignore:
                    break
                case .warning:
                    print("⚠️ Aiuta SDK Validation Warning:", message)
                case let .custom(logger):
                    logger.onValidationError(message)
                case .fatal:
                    fatalErrorCount += 1
                    print("🚨 Aiuta SDK Validation Error:", message)
            }
        }
    }
}

// MARK: - ValidationPolicy Convenience

extension Aiuta.Configuration.ValidationPolicy {
    fileprivate var isIgnored: Bool {
        if case .ignore = self { return true }
        return false
    }

    fileprivate var clampedToWarning: Self {
        if case .fatal = self { return .warning }
        return self
    }
}
