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

extension Aiuta {
    /// Aiuta SDK Configuration.
    /// All parameters are optional, you can only change the parts you are interested in.
    public struct Configuration {
        public static let `default` = Configuration()

        /// UI configuration.
        public var appearance = Appearance()

        /// Behavior configuration.
        public var behavior = Behavior()

        public init() {}
    }
}

extension Aiuta.Configuration {
    /// Various SDK behavior settings.
    public struct Behavior {
        /// Controls the availability of generation history to the user.
        /// When disabled the history will not be collected,
        /// the history screen will not be available and
        /// all previous generation history will be deleted.
        public var isHistoryAvailable: Bool = true

        /// Controls the availability of the add to wishlist button when viewing SKU information.
        public var isWishlistAvailable: Bool = true

        /// While waiting for the try-on result, try to highlight the human outline
        /// using iOS system tools on the animation screen . Works locally. iOS 15+.
        /// In case of failure, the normal animation of the loader will not be affected.
        public var tryGeneratePersonSegmentation: Bool = false

        /// Use additional splash screen before onboarding.
        public var isSplashScreenEnabled: Bool = false

        public struct Watermark {
            /// Optional watermark image that will be applied to share generated image.
            /// Watermark will fit within the (x: 0.5, y: 0.82, w: 0.45, h: 0.14) area of the generated image,
            /// but not exceeding the original size multiplied by the scale, aligned to the bottom-right corner of area.
            public var image: UIImage? = nil
        }

        /// Watermark configuration.
        /// Defined as structure for possible further extension of the watermark placement.
        public var watermark = Watermark()

        /// Controls the output of SDK debug logs.
        public var isDebugLogsEnabled: Bool = false
    }
}

extension Aiuta.Configuration {
    /// Settings for how the SDK will be displayed.
    public struct Appearance {
        public var presentationStyle: PresentationStyle = .pageSheet

        /// The language in which the SDK interface will be displayed.
        /// If not specified, the first preferred system language will be used
        /// if it is supported, otherwise English will be used.
        public var localization: Aiuta.Localization?

        public var colors = Colors()
        public var dimensions = Dimensions()
        public var fonts = Fonts()
        public var icons = Icons()
        public var images = Images()
        public var toggles = Toggles()
    }
}

// MARK: - Appearance.PresentationStyle

extension Aiuta.Configuration.Appearance {
    /// Defines how the SDL will be presented as modal view controller.
    public enum PresentationStyle: Equatable, Codable {
        ///
        case pageSheet
        case bottomSheet
        case fullScreen
    }
}

// MARK: - Appearance.Toggles

extension Aiuta.Configuration.Appearance {
    public struct Toggles {
        public var reduceShadows: Bool = false
        public var preferRightClose: Bool = false
        public var extendOnbordingNavBar: Bool = false
        public var applyProductFirstImageExtraInset: Bool = false
    }
}
