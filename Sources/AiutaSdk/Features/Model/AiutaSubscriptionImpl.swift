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
final class AiutaSubscriptionImpl: AiutaSubscription {
    let didResolveDetails = Signal<Void>(retainLastData: true)

    var shouldDisplayPoweredBy: Bool {
        powerdByLink.isSomeAndNotEmpty
    }

    var powerdByLink: String? {
        details?.poweredBySticker?.urlIos
    }

    @defaults(key: "subscriptionDetails", defaultValue: nil)
    var details: Aiuta.SubscriptionDetails?
    @injected private var api: ApiService

    func load() {
        Task { await load() }
    }

    func load() async {
        if details.isNil { $details.etag = nil }
        let (config, headers): (Aiuta.SubscriptionDetails, HTTPHeaders?)
        do {
            (config, headers) = try await api.request(Aiuta.SubscriptionDetails.Get(etag: $details.etag))
            $details.etag = headers?.etag
            details = config
            trace(details)
        } catch ApiError.statusCode(304, _) {
            trace(details)
        } catch {
            await asleep(.severalSeconds)
            await load()
        }
    }
}
