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

import Foundation

extension Aiuta {
    public enum Localization {
        case builtin(Builtin)
        case custom(AiutaSdkLanguage)
    }
}

extension Aiuta.Localization {
    public enum Builtin: Equatable {
        case English(Substitutions)
        case Turkish(Substitutions)
        case Russian(Substitutions)
    }
}

extension Aiuta.Localization.Builtin {
    public struct Substitutions: Equatable {
        let brandName: String
        let termsOfServiceUrl: String
        let privacyPolicyUrl: String

        public init(brandName: String, termsOfServiceUrl: String, privacyPolicyUrl: String) {
            self.brandName = brandName
            self.termsOfServiceUrl = termsOfServiceUrl
            self.privacyPolicyUrl = privacyPolicyUrl
        }
    }
}

public protocol AiutaSdkLanguage {
    /// `Try on`
    var tryOn: String { get }
    /// `Close`
    var close: String { get }
    /// `Cancel`
    var cancel: String { get }
    /// `Wishlist`
    var addToWish: String { get }
    /// `Add to cart`
    var addToCart: String { get }
    /// `Share`
    var share: String { get }
    /// `Try again`
    var tryAgain: String { get }
    /// `Something went wrong.`
    /// `Please try again later`
    var defaultErrorMessage: String { get }

    // MARK: - App bar

    /// `Virtual Try-on`
    var appBarVirtualTryOn: String { get }
    /// `History`
    var appBarHistory: String { get }
    /// `Select`
    var appBarSelect: String { get }

    // MARK: - Splash

    /// `Try on you`
    var preOnboardingTitle: String { get }
    /// `Welcome to our Virtual try-on.`
    /// `Try on the item directly`
    /// `on your photo`
    var preOnboardingSubtitle: String { get }
    /// `Let’s start`
    var preOnboardingButton: String { get }

    // MARK: - Onboarding

    /// `<b>Step 1/3</b> - How it works`
    var onboardingAppbarTryonPage: String { get }
    /// `Try on before buying`
    var onboardingPageTryonTopic: String { get }
    /// `Upload a photo and see how items look on you`
    var onboardingPageTryonSubtopic: String { get }

    /// `<b>Step 2/3</b> - For best result`
    var onboardingAppbarBestResultPage: String { get }
    /// `For best results`
    var onboardingPageBestResultTopic: String { get }
    /// `Use a photo with good lighting, stand straight a plain background`
    var onboardingPageBestResultSubtopic: String { get }

    /// `<b>Step 3/3</b> - Consent`
    var onboardingAppbarConsentPage: String { get }
    /// `Consent`
    var onboardingPageConsentTopic: String { get }
    /// `In order to try on items digitally, you agree to allow $brandName to process your photo.`
    /// `Your data will be processed according to the $brandName <b><a href='$privacyPolicyUrl'>Privacy Notice</a></b>`
    /// `and <b><a href='$termsOfServiceUrl'>Terms of Use.</a></b>`
    var onboardingPageConsentBody: String { get }
    /// `I agree to allow $brandName to process my photo`
    var onboardingPageConsentAgreePoint: String { get }

    /// `Next`
    var onboardingButtonNext: String { get }
    /// `Start`
    var onboardingButtonStart: String { get }

    // MARK: - Image selector

    /// `Upload a photo of you`
    var imageSelectorUploadButton: String { get }
    /// `Change photo`
    var imageSelectorChangeButton: String { get }
    /// `Your photos are protected and visible only to you`
    var imageSelectorProtectionPoint: String { get }
    /// `Powered by Aiuta`
    var imageSelectorPoweredByAiuta: String { get }

    // MARK: - Loading

    /// `Uploading image`
    var loadingUploadingImage: String { get }
    /// `Scanning your body`
    var loadingScanningBody: String { get }
    /// `Generating outfit`
    var loadingGeneratingOutfit: String { get }
    /// `We couldn’t detect anyone in this photo`
    var dialogInvalidImageDescription: String { get }

    // MARK: - Generation Result

    /// `You might also like`
    var generationResultMoreTitle: String { get }
    /// `More for you to try on`
    var generationResultMoreSubtitle: String { get }

    // MARK: - History

    /// `Select`
    var historySelectorDisabledButton: String { get }
    /// `Select all`
    var historySelectorEnableButtonSelectAll: String { get }
    /// `Unselect all`
    var historySelectorEnableButtonUnselectAll: String { get }
    /// `Cancel`
    var historySelectorEnableButtonCancel: String { get }

    // MARK: - Photo picker sheet

    /// `Take a photo`
    var pickerSheetTakePhoto: String { get }
    /// `Choose from library`
    var pickerSheetChooseLibrary: String { get }

    // MARK: - Uploads history sheet

    /// `Previously used photos`
    var uploadsHistorySheetPreviously: String { get }
    /// `+ Upload new photo`
    var uploadsHistorySheetUploadNewButton: String { get }

    // MARK: - Feedback sheet

    /// `Can you tell us more?`
    var feedbackSheetTitle: String { get }
    /// `This style isn’t for me`
    /// `The item looks off`
    /// `I look different`
    var feedbackSheetOptions: [String] { get }
    /// `Skip`
    var feedbackSheetSkip: String { get }
    /// `Send`
    var feedbackSheetSend: String { get }

    /// `Other`
    var feedbackSheetExtraOption: String { get }
    /// `Tell us what we could improve?`
    var feedbackSheetExtraOptionTitle: String { get }
    /// `Send feedback`
    var feedbackSheetSendFeedback: String { get }
    /// `Thank you for your feedback`
    var feedbackSheetGratitude: String { get }

    // MARK: - Fet disclaimer

    /// `Results may vary from real-life fit`
    var fitDisclaimerTitle: String { get }
    /// `Virtual try-on is a visualization tool that shows`
    /// `how items might look and may not perfectly represent`
    /// `how the item will fit in reality`
    var fitDisclaimerBody: String { get }

    // MARK: - Camera permission

    /// `Camera permission`
    var dialogCameraPermissionTitle: String { get }
    /// `Please allow access to the camera in the application settings`
    var dialogCameraPermissionDescription: String { get }
    /// `Settings`
    var dialogCameraPermissionConfirmButton: String { get }
}
