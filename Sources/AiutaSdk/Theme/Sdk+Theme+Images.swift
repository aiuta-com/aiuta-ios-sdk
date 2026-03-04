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

#if SWIFT_PACKAGE
@_spi(Aiuta) import AiutaAssets
import AiutaConfig
import AiutaCore
@_spi(Aiuta) import AiutaKit
#endif
import Resolver
import UIKit

extension Sdk.Theme {
    struct Images {
        let config: Aiuta.Configuration

        // MARK: - Welcome Screen

        var welcomeBackground: UIImage? { config.features.welcomeScreen?.images.welcomeBackground }

        // MARK: - Onboarding

        var onboardingHowItWorksItems: [(photo: UIImage?, preview: UIImage?)] {
            config.features.onboarding?.howItWorks.images.onboardingHowItWorksItems.map {
                (photo: $0.itemPhoto, preview: $0.itemPreview)
            } ?? []
        }

        var onboardingBestResultsGood: [UIImage] { config.features.onboarding?.bestResults?.images.onboardingBestResultsGood ?? [] }
        var onboardingBestResultsBad: [UIImage] { config.features.onboarding?.bestResults?.images.onboardingBestResultsBad ?? [] }

        // MARK: - ImagePicker

        var imagePickerExamples: [UIImage] { config.features.imagePicker.images.imagePickerExamples }

        // MARK: - Share

        var shareWatermark: UIImage? { config.features.share?.watermark?.images.watermark }
    }
}

// MARK: - Image Traits

extension Sdk.Theme {
    final class Traits: ImageTraits {
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
                    @injected var subscription: Sdk.Core.Subscription
                    return subscription.retryCounts.resultDownload
            }
        }
    }
}

// MARK: - Watermark

extension Sdk.Theme {
    final class Watermarker: FitAreaWatermarker {
        init(_ config: Aiuta.Configuration) {
            super.init(config.features.share?.watermark?.images.watermark,
                       area: .init(x: 0.5, y: 0.82, width: 0.45, height: 0.14),
                       xAlign: .max, yAlign: .max)
        }
    }
}
