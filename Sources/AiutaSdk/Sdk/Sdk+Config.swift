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
import Foundation
import UIKit

// MARK: - Auth

extension Aiuta.Configuration {
    var keyToDefaults: String {
        switch auth {
            case let .apiKey(apiKey): return apiKey
            case let .jwt(subscriptionId, _): return subscriptionId
        }
    }
}

// MARK: - Analytics

extension Aiuta.Analytics {
    var handler: Handler? {
        switch self {
            case .none: return nil
            case let .handler(handler): return handler
        }
    }
}

// MARK: - Consent

extension Aiuta.Configuration.Features.Consent {
    var isEmbedded: Bool {
        if case .embeddedIntoOnboarding = self { return true }
        return false
    }

    var isStandaloneOnboarding: Bool {
        if case .standaloneOnboardingPage = self { return true }
        return false
    }

    var isStandaloneImagePicker: Bool {
        if case .standaloneImagePickerPage = self { return true }
        return false
    }

    var consents: [Aiuta.Consent] {
        switch self {
            case .none, .embeddedIntoOnboarding:
                return []
            case let .standaloneOnboardingPage(standalone):
                return standalone.data.consents
            case let .standaloneImagePickerPage(standalone):
                return standalone.data.consents
        }
    }

    var onObtain: (([String]) -> Void)? {
        switch self {
            case .none, .embeddedIntoOnboarding:
                return nil
            case let .standaloneOnboardingPage(standalone):
                return standalone.data.onObtain
            case let .standaloneImagePickerPage(standalone):
                return standalone.data.onObtain
        }
    }
}

extension Aiuta.Configuration.Features.Consent.Standalone.ConsentProvider {
    var consents: [Aiuta.Consent] {
        switch self {
            case let .userDefaults(consents): return consents
            case let .userDefaultsWithCallback(consents, _): return consents
            case let .dataProvider(consents, _): return consents
        }
    }

    var onObtain: (([String]) -> Void)? {
        switch self {
            case .userDefaults: return nil
            case let .userDefaultsWithCallback(_, onObtain): return onObtain
            case .dataProvider: return nil
        }
    }
}

// MARK: - Consent Standalone

extension Aiuta.Configuration.Features.Consent {
    var standalone: Standalone? {
        switch self {
            case let .standaloneOnboardingPage(s): return s
            case let .standaloneImagePickerPage(s): return s
            default: return nil
        }
    }
}

// MARK: - Share Watermark

extension Aiuta.Configuration.Features.Share.Watermark {
    var image: UIImage? {
        switch self {
            case .none: return nil
            case let .custom(shareWatermark): return shareWatermark
            case let .provider(provider): return provider.shareWatermark
        }
    }
}

// MARK: - Share

extension Aiuta.Configuration.Features.Share {
    var additionalTextProvider: DataProvider? {
        switch text {
            case .none: return nil
            case let .dataProvider(provider): return provider
        }
    }

    var hasWatermark: Bool {
        switch watermark {
            case .none: return false
            case .custom, .provider: return true
        }
    }
}

// MARK: - Consent type

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
