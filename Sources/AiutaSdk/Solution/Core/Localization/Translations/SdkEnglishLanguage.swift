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

struct SdkEnglishLanguage: AiutaSdkLanguage {
    let substitutions: Aiuta.Localization.Builtin.Substitutions

    init(_ substitutions: Aiuta.Localization.Builtin.Substitutions) {
        self.substitutions = substitutions
    }

    let tryOn = "Try on"
    let close = "Close"
    let cancel = "Cancel"
    let addToWish = "Wishlist"
    let addToCart = "Add to cart"
    let share = "Share"
    let tryAgain = "Try again"
    let defaultErrorMessage = "Something went wrong.\nPlease try again later"

    // MARK: - App bar

    let appBarVirtualTryOn = "Virtual Try-on"
    let appBarHistory = "History"
    let appBarSelect = "Select"

    // MARK: - Splash

    let preOnboardingTitle = "Try on you"
    let preOnboardingSubtitle = "Welcome to our Virtual try-on.\nTry on the item directly\non your photo"
    let preOnboardingButton = "Let’s start"

    // MARK: - Onboarding

    let onboardingAppbarTryonPage = "\(Html("Step 1/3", .bold)) - How it works"
    let onboardingPageTryonTopic = "Try on before buying"
    let onboardingPageTryonSubtopic = "Upload a photo and see how items look on you"

    let onboardingAppbarBestResultPage = "\(Html("Step 2/3", .bold)) - For best result"
    let onboardingPageBestResultTopic = "For best results"
    let onboardingPageBestResultSubtopic = "Use a photo with good lighting, stand straight a plain background"

    let onboardingAppbarConsentPage = "\(Html("Step 3/3", .bold)) - Consent"
    let onboardingPageConsentTopic = "Consent"

    var onboardingPageConsentBody: String { """
        In order to try on items digitally, you agree to allow \(substitutions.brandName) to process your photo.
        Your data will be processed according to the \(substitutions.brandName) \(Html("Privacy Notice", .link(substitutions.privacyPolicyUrl), .bold))
        and <b><a href='\(substitutions.termsOfServiceUrl)'>Terms of Use.</a></b>
    """
    }

    var onboardingPageConsentAgreePoint: String { "I agree to allow \(substitutions.brandName) to process my photo" }

    var onboardingPageConsentSupplementaryPoints: [String] {
        substitutions.supplementaryConsents
    }

    let onboardingPageConsentFooter: String? = nil

    let onboardingButtonNext = "Next"
    let onboardingButtonStart = "Start"

    // MARK: - Image selector

    let imageSelectorUploadButton = "Upload a photo of you"
    let imageSelectorChangeButton = "Change photo"
    let imageSelectorProtectionPoint = "Your photos are protected and visible only&nbsp;to&nbsp;you"
    let imageSelectorPoweredByAiuta = "Powered by Aiuta"

    // MARK: - Loading

    let loadingUploadingImage = "Uploading image"
    let loadingScanningBody = "Scanning your body"
    let loadingGeneratingOutfit = "Generating outfit"
    let dialogInvalidImageDescription = "We couldn’t detect\nanyone in this photo"

    // MARK: - Generation Result

    let generationResultMoreTitle = "You might also like"
    let generationResultMoreSubtitle = "More for you to try on"

    // MARK: - History

    let historySelectorEnableButtonSelectAll = "Select all"
    let historySelectorEnableButtonUnselectAll = "Unselect all"

    // MARK: - Photo picker sheet

    let pickerSheetTakePhoto = "Take a photo"
    let pickerSheetChooseLibrary = "Choose from library"

    // MARK: - Uploads history sheet

    let uploadsHistorySheetPreviously = "Previously used photos"
    let uploadsHistorySheetUploadNewButton = "+ Upload new photo"

    // MARK: - Feedback sheet

    let feedbackSheetTitle = "Can you tell us more?"
    let feedbackSheetOptions = ["This style isn’t for me", "The item looks off", "I look different"]
    let feedbackSheetSkip = "Skip"
    let feedbackSheetSend = "Send"

    let feedbackSheetExtraOption = "Other"
    let feedbackSheetExtraOptionTitle = "Tell us what we could improve?"
    let feedbackSheetSendFeedback = "Send feedback"
    let feedbackSheetGratitude = "Thank you for your feedback"

    // MARK: - Fet disclaimer

    let fitDisclaimerTitle = "Results may vary from real-life fit"
    let fitDisclaimerBody = "Virtual try-on is a visualization tool that shows how items might look and may not perfectly represent how the item will fit in reality"

    // MARK: - Camera permission

    let dialogCameraPermissionTitle = "Camera permission"
    let dialogCameraPermissionDescription = "Please allow access to the camera in the application settings"
    let dialogCameraPermissionConfirmButton = "Settings"
}
