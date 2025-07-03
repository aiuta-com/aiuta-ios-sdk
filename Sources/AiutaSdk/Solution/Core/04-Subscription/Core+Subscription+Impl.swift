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
    final class SubscriptionImpl: Subscription {
        let didResolveDetails = Signal<Void>(retainLastData: true)
        let didFailToResolveDetails = Signal<Void>()
        
        var shouldDisplayPoweredBy: Bool {
            details.poweredBySticker.isVisible
        }
        
        var powerdByLink: String? {
            details.poweredBySticker.urlIos
        }
        
        var retryCounts: Aiuta.SubscriptionDetails.RetryCounts {
            details.retryCounts
        }
        
        var operationDelays: any IteratorProtocol<AsyncDelayTime> {
            details.operationDelaysSequence
        }
        
        @injected private var api: ApiService
        
        @defaults(key: "subscriptionDetails", defaultValue: Aiuta.SubscriptionDetails())
        var details: Aiuta.SubscriptionDetails
        
        @defaults(key: "subscriptionVersion", defaultValue: 1)
        private var detailsVersion: Int
        private var targetVersion = 3
        
        func load() {
            Task { await load() }
        }
        
        @MainActor func load() async {
            if detailsVersion < targetVersion { _details.etag = nil }
            let (config, headers): (Aiuta.SubscriptionDetails, HTTPHeaders?)
            do {
                (config, headers) = try await api.request(Aiuta.SubscriptionDetails.Get(etag: _details.etag))
                _details.etag = headers?.etag
                detailsVersion = targetVersion
                details = config
                didResolveDetails.fire()
            } catch ApiError.notModified {
                didResolveDetails.fire()
            } catch {
                didFailToResolveDetails.fire()
                await asleep(.severalSeconds)
                await load()
            }
        }
    }
}
