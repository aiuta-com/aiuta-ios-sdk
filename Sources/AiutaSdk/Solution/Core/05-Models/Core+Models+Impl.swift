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
import Alamofire
import Foundation

@available(iOS 13.0.0, *)
extension Sdk.Core {
    final class ModelsImpl: Models {
        let didLoadModels: Signal<Void> = Signal<Void>(retainLastData: true)
        let didFailToLoadModels: Signal<Void> = Signal<Void>()

        @defaults(key: "predefinedTryOnModels", defaultValue: [])
        var predefinedModels: Sdk.Core.Api.Models

        @injected private var api: ApiService
        @injected private var config: Sdk.Configuration

        func load() {
            Task { await load() }
        }

        @MainActor func load() async {
            guard config.features.imagePicker.hasPredefinedModels else { return }
            let (models, headers): (Sdk.Core.Api.Models, HTTPHeaders?)
            do {
                (models, headers) = try await api.request(Sdk.Core.Api.Models.Get(etag: _predefinedModels.etag))
                _predefinedModels.etag = headers?.etag
                predefinedModels = models
                didLoadModels.fire()
            } catch ApiError.notModified {
                didLoadModels.fire()
            } catch {
                didFailToLoadModels.fire()
                await asleep(.severalSeconds)
                await load()
            }
        }
    }
}
