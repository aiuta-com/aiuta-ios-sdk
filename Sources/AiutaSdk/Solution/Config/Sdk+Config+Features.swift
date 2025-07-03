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

import UIKit

extension Sdk.Configuration {
    struct Features {
        var analytics = Analytics()
        var welcomeScreen = WelcomeScreen()
        var onboarding = Onboarding()
        var consent = Consent()
        var imagePicker = ImagePicker()
        var tryOn = TryOn()
        var share = Share()
        var wishlist = Wishlist()
    }
}

extension Sdk.Configuration.Features {
    struct Analytics {
        var handler: Aiuta.Analytics.Handler?
    }

    struct WelcomeScreen {
        var isEnabled: Bool = false
    }

    struct Onboarding {
        var isEnabled: Bool = true
        var hasBestResults: Bool = false
        var dataProvider: Aiuta.Configuration.Features.Onboarding.DataProvider = DefaultsDataProvider()
    }

    struct Consent {
        var isEmbedded: Bool = true
        var isOnboarding: Bool = false
        var isUploadButton: Bool = false
        var consents: [Aiuta.Consent] = []
        var onObtain: ([String]) -> Void = { _ in }
        var dataProvider: Aiuta.Configuration.Features.Consent.Standalone.DataProvider = DefaultsDataProvider()
    }

    struct ImagePicker {
        var hasCamera: Bool = true
        var hasPredefinedModels: Bool = true
        var hasUploadsHistory: Bool = true
        var preferredPredefinedModelsCategoryId: String? = nil
        var historyProvider: Aiuta.Configuration.Features.ImagePicker.UploadsHistory.DataProvider = DefaultsDataProvider()
    }

    struct TryOn {
        var allowsBackgroundExecution: Bool = true
        var tryGeneratePersonSegmentation: Bool = true
        var showsFitDisclaimerOnResults: Bool = true
        var askForUserFeedbackOnResults: Bool = true
        var askForOtherFeedbackOnResults: Bool = true
        var hasGenerationsHistory: Bool = true
        var canContinueWithOtherPhoto: Bool = true
        var cartHandler: Aiuta.Configuration.Features.TryOn.Cart.Handler?
        var historyProvider: Aiuta.Configuration.Features.TryOn.GenerationsHistory.DataProvider = DefaultsDataProvider()
    }

    struct Share {
        var isEnabled: Bool = true
        var additionalTextProvider: Aiuta.Configuration.Features.Share.AdditionalTextProvider.DataProvider?
    }

    struct Wishlist {
        var isEnabled: Bool = true
        var dataProvider: Aiuta.Configuration.Features.Wishlist.DataProvider?
    }
}

extension Aiuta.Consent {
    var isRequired: Bool {
        switch type {
            case .implicit:
                return true
            case let .explicit(isRequired):
                return isRequired
        }
    }
}
