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

import AiutaCore
@_spi(Aiuta) import AiutaKit

@available(iOS 13.0.0, *)
extension Sdk.Core {
    actor ConsentImpl: Consent {
        @injected var config: Sdk.Configuration

        var isGiven: Bool {
            get async {
                let obtainedConsentsIds = await config.features.consent.dataProvider.obtainedConsentsIds.value
                return config.features.consent.consents.filter { $0.isRequired}.map { $0.id }.allSatisfy {
                    obtainedConsentsIds.contains($0)
                }
            }
        }

        var isRequiredOnBoarding: Bool {
            get async {
                guard config.features.consent.isOnboarding else { return false }
                return await !isGiven
            }
        }

        var isRequiredOnImagePicker: Bool {
            get async {
                guard config.features.consent.isUploadButton else { return false }
                return await !isGiven
            }
        }
        
        func obtain(consentsIds: [String]) async {
            await config.features.consent.dataProvider.obtain(consentsIds: consentsIds)
        }
    }
}

extension Sdk.Configuration.Features.Consent {
    final class DefaultsDataProvider: Aiuta.Configuration.Features.Consent.Standalone.DataProvider {
        @MainActor
        @defaults(key: "obtainedConsentsIds", defaultValue: .init([]))
        var obtainedConsentsIds: Aiuta.Observable<[String]>

        @MainActor
        func obtain(consentsIds: [String]) {
            obtainedConsentsIds.value = consentsIds
        }
    }
}
