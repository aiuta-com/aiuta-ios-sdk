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
import Foundation

extension Aiuta.SubscriptionDetails {
    init() {
        poweredBySticker = PoweredBySticker()
        retryCounts = RetryCounts()
        operationDelaysSequence = OperationDelaysSequence()
    }
}

extension Aiuta.SubscriptionDetails.PoweredBySticker {
    init() {
        urlIos = nil
        isVisible = false
    }
}

extension Aiuta.SubscriptionDetails.RetryCounts {
    init() {
        photoUpload = 2
        operationStart = 0
        operationStatus = 2
        resultDownload = 2
    }
}

extension Aiuta.SubscriptionDetails.OperationDelaysSequence.OperationDelay {
    static let defaultSequence: [Aiuta.SubscriptionDetails.OperationDelaysSequence.OperationDelay] = [
        .init(recurring: 1, count: 4),
        .init(recurring: 0.5, count: 20),
        .init(infinite: 3),
    ]

    private init(recurring delay: TimeInterval, count: Int) {
        mode = .recurring(count)
        self.delay = delay
    }

    private init(infinite delay: TimeInterval) {
        mode = .infinite
        self.delay = delay
    }
}
