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

import AiutaConfig
import AiutaCore
@_spi(Aiuta) import AiutaKit
import UIKit

extension Sdk.Theme {
    struct Features {
        let config: Aiuta.Configuration

        var consent: Consent { .init(config: config) }
        var onboarding: Onboarding { .init(config: config) }
        var imagePicker: ImagePicker { .init(config: config) }
        var tryOn: TryOn { .init(config: config) }
        var share: Share { .init(config: config) }
        var wishlist: Wishlist { .init(config: config) }
    }
}

extension Sdk.Theme.Features {
    struct Consent {
        let config: Aiuta.Configuration

        var isEmbedded: Bool { config.features.consent.isEmbedded }
        var isOnboarding: Bool { config.features.consent.isStandaloneOnboarding }
        var consents: [Aiuta.Consent] { config.features.consent.consents }
    }

    struct Onboarding {
        let config: Aiuta.Configuration

        var isEnabled: Bool { config.features.onboarding != nil }
        var hasBestResults: Bool { config.features.onboarding?.bestResults != nil }
    }

    struct ImagePicker {
        let config: Aiuta.Configuration

        var hasPredefinedModels: Bool { config.features.imagePicker.predefinedModels != nil }
        var hasProtectionDisclaimer: Bool { config.features.imagePicker.protectionDisclaimer != nil }
        var preferredPredefinedModelsCategoryId: String? { config.features.imagePicker.predefinedModels?.data.preferredCategoryId }
    }

    struct TryOn {
        let config: Aiuta.Configuration

        var allowsBackgroundExecution: Bool { config.features.tryOn.toggles.allowsBackgroundExecution }
        var canContinueWithOtherPhoto: Bool { config.features.tryOn.otherPhoto != nil }
        var showsFitDisclaimerOnResults: Bool { config.features.tryOn.fitDisclaimer != nil }
        var askForUserFeedbackOnResults: Bool { config.features.tryOn.feedback != nil }
        var askForOtherFeedbackOnResults: Bool { config.features.tryOn.feedback?.other != nil }
    }

    struct Share {
        let config: Aiuta.Configuration

        var isEnabled: Bool { config.features.share != nil }
    }

    struct Wishlist {
        let config: Aiuta.Configuration

        var isEnabled: Bool { config.features.wishlist != nil }
    }
}
