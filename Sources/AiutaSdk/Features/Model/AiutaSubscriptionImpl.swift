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

final class AiutaSubscriptionImpl: AiutaSubscription {
    let didResolveDetails = Signal<Void>(retainLastData: true)

    var shouldDisplayPoweredBy: Bool {
        powerdByLink.isSomeAndNotEmpty
    }

    var powerdByLink: String? {
        details?.poweredBySticker?.urlIos
    }

    var shouldDisplayFitDisclaimer: Bool {
        L[fitDisclaimer?.title].isSomeAndNotEmpty
    }

    var fitDisclaimer: Aiuta.SubscriptionDetails.Disclaimer? {
        details?.sizeAndFitDisclaimer
    }

    var shouldDisplayFeedback: Bool {
        L[feedback?.gratitudeMessage].isSomeAndNotEmpty
    }

    var feedback: Aiuta.SubscriptionDetails.Feedback? {
        details?.feedback
    }

    @defaults(key: "subscriptionDetails", defaultValue: nil)
    var details: Aiuta.SubscriptionDetails?
    @injected private var api: ApiService

    @defaults(key: "subscriptionVersion", defaultValue: 1)
    private var detailsVersion: Int
    private var targetVersion = 2

    func load() {
        Task { await load() }
    }

    func load() async {
        if details.isNil || detailsVersion < targetVersion { $details.etag = nil }
        let (config, headers): (Aiuta.SubscriptionDetails, HTTPHeaders?)
        do {
            (config, headers) = try await api.request(Aiuta.SubscriptionDetails.Get(etag: $details.etag))
            $details.etag = headers?.etag
            detailsVersion = targetVersion
            details = config
        } catch ApiError.notModified {
            trace(details)
        } catch {
            await asleep(.severalSeconds)
            await load()
        }
    }
}
