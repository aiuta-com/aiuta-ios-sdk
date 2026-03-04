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

@available(iOS 13.0.0, *)
extension Sdk.Core {
    actor OnboardingImpl: Onboarding {
        @injected var config: Aiuta.Configuration

        var needsWelcome: Bool {
            get async {
                guard config.features.welcomeScreen != nil else { return false }
                guard let onboarding = config.features.onboarding else { return true }
                return await !onboarding.dataProvider.isOnboardingCompleted
            }
        }

        var needsOnboarding: Bool {
            get async {
                guard let onboarding = config.features.onboarding else { return false }
                return await !onboarding.dataProvider.isOnboardingCompleted
            }
        }

        func complete() async {
            guard let onboarding = config.features.onboarding else { return }
            await onboarding.dataProvider.completeOnboarding()
        }
    }
}

extension Aiuta.Configuration.Features.Onboarding {
    var dataProvider: DataProvider {
        switch data {
            case .userDefaults:
                return OnboardingDefaultsDataProvider()
            case let .dataProvider(provider):
                return provider
        }
    }
}

fileprivate final class OnboardingDefaultsDataProvider: Aiuta.Configuration.Features.Onboarding.DataProvider {
    @MainActor
    @defaults(key: "isOnboardingCompleted", defaultValue: false)
    var isOnboardingCompleted: Bool

    @MainActor
    func completeOnboarding() {
        isOnboardingCompleted = true
    }
}
