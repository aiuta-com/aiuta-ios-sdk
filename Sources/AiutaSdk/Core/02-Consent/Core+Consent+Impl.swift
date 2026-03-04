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
    actor ConsentImpl: Consent {
        @injected var config: Aiuta.Configuration

        private lazy var dataProvider: Aiuta.Configuration.Features.Consent.Standalone.DataProvider = {
            config.features.consent.resolveConsentDataProvider()
        }()

        var isGiven: Bool {
            get async {
                let obtainedConsentsIds = await dataProvider.obtainedConsentsIds.value
                return config.features.consent.consents.filter { $0.isRequired }.map { $0.id }.allSatisfy {
                    obtainedConsentsIds.contains($0)
                }
            }
        }

        var isRequiredOnBoarding: Bool {
            get async {
                guard config.features.consent.isStandaloneOnboarding else { return false }
                return await !isGiven
            }
        }

        var isRequiredOnImagePicker: Bool {
            get async {
                guard config.features.consent.isStandaloneImagePicker else { return false }
                return await !isGiven
            }
        }

        func obtain(consentsIds: [String]) async {
            await dataProvider.obtain(consentsIds: consentsIds)
        }
    }
}

extension Aiuta.Configuration.Features.Consent {
    func resolveConsentDataProvider() -> Standalone.DataProvider {
        switch self {
            case .none, .embeddedIntoOnboarding:
                return ConsentDefaultsDataProvider()
            case let .standaloneOnboardingPage(standalone),
                 let .standaloneImagePickerPage(standalone):
                switch standalone.data {
                    case .userDefaults, .userDefaultsWithCallback:
                        return ConsentDefaultsDataProvider()
                    case let .dataProvider(_, provider):
                        return provider
                }
        }
    }
}

fileprivate final class ConsentDefaultsDataProvider: Aiuta.Configuration.Features.Consent.Standalone.DataProvider {
    @MainActor
    @defaults(key: "obtainedConsentsIds", defaultValue: .init([]))
    var obtainedConsentsIds: Aiuta.Observable<[String]>

    @MainActor
    func obtain(consentsIds: [String]) {
        obtainedConsentsIds.value = consentsIds
        _obtainedConsentsIds.write()
    }
}
