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
import Resolver
import UIKit

final class SdkImageTraits: ImageTraits {
    func largestSize(for quality: ImageQuality) -> CGFloat {
        switch quality {
            case .thumbnails: return 400
            case .hiResImage: return 1500
        }
    }

    func retryCount(for quality: ImageQuality) -> Int {
        switch quality {
            case .thumbnails:
                return 5
            case .hiResImage:
                @injected var subscription: SubscriptionModel
                return subscription.retryCounts.resultDownload
        }
    }
}
