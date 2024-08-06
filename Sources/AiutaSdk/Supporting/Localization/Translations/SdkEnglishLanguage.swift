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

struct SdkEnglishLanguage: SdkLanguage {
    subscript(_ variants: Aiuta.StringVariants?) -> String? { variants?.en }

    // General
    let tryOn = "Try on" // Try on
    let share = "Share" // Share
    let addToCart = "Add to cart" // Add to cart
    let addToWishlist = "Add to wishlist" // Add to wishlist
    let moreDetails = "More details" // More details
    let somethingWrong = "Something went wrong" // Something went wrong
    let tryAgain = "Something went wrong.\nPlease try again later" // Something went wrong. Please try again later
    let cancel = "Cancel" // Cancel
    let settings = "Settings" // Settings
    let send = "Send" // Send
    let skip = "Skip" // Skip

    // App bar
    let history = "History" // History
    let select = "Select" // Select

    // Onboarding
    let next = "Next" // Next
    let start = "Start" // Start

    let onboardingTryonTitle = "Try on before buying" // Try on before buying
    let onboardingTryonDescription = "Just upload your photo\nand see how it looks" // Just upload your photo and see how it looks

    let onboardingBestResultsTitle = "For best results" // For best results
    let onboardingBestResultsDescription = "Use a photo with good lighting,\nstand straight a plain background" // Use a photo with good lighting, stand straight a plain background
    let onboardingLegalDisclaimer = "Your photo is processed as per the&nbsp;<u>Clarification Text</u>" // Your photo is processed as per the Clarification Text

    // Image selector
    let imageSelectorUploadButton = "Upload a photo of you" // Upload a photo of you
    let imageSelectorChangeButton = "Change photo" // Change photo
    let poweredBy = "Powered by " // Powered by
    let aiuta = "Aiuta"
    let imageSelectorPhotos: Pluralize = { "\($0) photos" } // N photos
    let imageSelectorCameraPermission = "Please allow access to the camera in the application settings." // Please allow access to the camera in the application settings.

    // Generation
    let generatingUpload = "Uploading image" // Uploading image
    let generatingScanBody = "Scanning your body" // Scanning your body
    let generatingOutfit = "Generating outfit" // Generating outfit

    // History
    let selectAll = "Select all" // Select all
    let selectNone = "Select none" // Select none
    let historyEmptyDescription = "Once you try on first item your\ntry-on history would be stored here" // Once you try on first item your try-on history would be stored here

    // Generation Result
    let generationResultMoreTitle = "More for you to try on" // More for you to try on
    let generationResultSwipeUp = "Swipe up for more" // Swipe up for more

    // Picker sheet
    let pickerSheetTakePhoto = "Take a photo" // Take a photo
    let pickerSheetChooseLibrary = "Choose from library" // Choose from library

    // Upload history sheet
    let uploadHistorySheetPreviously = "Previously used photos" // Previously used photos
    let uploadHistorySheetUploadNewButton = "+ Upload new photo" // + Upload new photo
    
    // Feedback
    let feedbackSend = "Send feedback" // Send feedback
    let feedbackCancel = "Cancel" // Cancel
}
