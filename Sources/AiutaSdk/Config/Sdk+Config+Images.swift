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

@_spi(Aiuta) import AiutaAssets
import AiutaCore
@_spi(Aiuta) import AiutaKit
import Resolver
import UIKit

extension Sdk.Configuration {
    struct Images {
        // MARK: - Welcome Screen

        var welcomeBackground: UIImage?

        // MARK: - Onboarding

        var onboardingHowItWorksItems: [(photo: UIImage?, preview: UIImage?)] = [
            (photo: AiutaAssets.bundleImage("aiutaImageBoardHow1L"), preview: AiutaAssets.bundleImage("aiutaImageBoardHow1S")),
            (photo: AiutaAssets.bundleImage("aiutaImageBoardHow2L"), preview: AiutaAssets.bundleImage("aiutaImageBoardHow2S")),
            (photo: AiutaAssets.bundleImage("aiutaImageBoardHow3L"), preview: AiutaAssets.bundleImage("aiutaImageBoardHow3S")),
        ]

        var onboardingBestResultsGood: [UIImage] = []
        var onboardingBestResultsBad: [UIImage] = []

        // MARK: - ImagePicker

        var imagePickerExamples: [UIImage] = [
            AiutaAssets.bundleImage("aiutaImagePickerSample1"),
            AiutaAssets.bundleImage("aiutaImagePickerSample2"),
        ].compactMap { $0 }

        // MARK: - Share

        var shareWatermark: UIImage?
    }
}

// MARK: - Image Traits

extension Sdk.Configuration.Images {
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

extension Sdk.Configuration.Images {
    final class Watermarker: FitAreaWatermarker {
        init(_ configuration: Sdk.Configuration.Images) {
            super.init(configuration.shareWatermark,
                       area: .init(x: 0.5, y: 0.82, width: 0.45, height: 0.14),
                       xAlign: .max, yAlign: .max)
        }
    }
}
