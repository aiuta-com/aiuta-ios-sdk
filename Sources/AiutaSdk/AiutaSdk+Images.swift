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

import UIKit

// MARK: - Appearance.Icons & Images

extension Aiuta.Configuration.Appearance {
    /// Icon overrides
    public struct Icons {
        public var icons14 = Icons14()
        public var icons16 = Icons16()
        public var icons20 = Icons20()
        public var icons24 = Icons24()
        public var icons36 = Icons36()
        public var icons82 = Icons82()

        public init() {}
    }

    /// Image overrides
    public struct Images {
        public var splashScreen: UIImage?
        public var onboarding = Onboarding()
        public var selectorPlaceholder: UIImage?
        public var feedbackGratitude: UIImage?

        public init() {}
    }
}

extension Aiuta.Configuration.Appearance.Icons {
    public struct Icons14 {
        public var spin: UIImage?
    }

    public struct Icons16 {
        public var magic: UIImage?
        public var lock: UIImage?
        public var arrow: UIImage?
    }

    public struct Icons20 {
        public var check: UIImage?
        public var info: UIImage?
    }

    public struct Icons24 {
        public var back: UIImage?
        public var camera: UIImage?
        public var cameraSwap: UIImage?
        public var checkCorrect: UIImage?
        public var checkNotCorrect: UIImage?
        public var close: UIImage?
        public var trash: UIImage?
        public var history: UIImage?
        public var photoLibrary: UIImage?
        public var share: UIImage?
        public var wishlist: UIImage?
        public var wishlistFill: UIImage?
    }

    public struct Icons36 {
        public var error: UIImage?
        public var like: UIImage?
        public var dislike: UIImage?
        public var imageError: UIImage?
    }

    public struct Icons82 {
        public var splash: UIImage?
    }
}

extension Aiuta.Configuration.Appearance.Images {
    public struct Onboarding {
        public var onboardingTryOnMainImage1: UIImage?
        public var onboardingTryOnMainImage2: UIImage?
        public var onboardingTryOnMainImage3: UIImage?

        public var onboardingTryOnItemImage1: UIImage?
        public var onboardingTryOnItemImage2: UIImage?
        public var onboardingTryOnItemImage3: UIImage?

        public var onboardingBestResulGoodImage1: UIImage?
        public var onboardingBestResulGoodImage2: UIImage?
        public var onboardingBestResulBadImage1: UIImage?
        public var onboardingBestResulBadImage2: UIImage?
    }
}
