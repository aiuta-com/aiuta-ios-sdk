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
        public var isTryonHistoryAvailable: Bool = true

        /// Controls the availability of uploads history to the user.
        /// When disabled the history will not be collected,
        /// the history bottomsheet will not be available and
        /// all previous uploaded images will be deleted.
        public var isUploadsHistoryAvailable: Bool = true

        /// Controls the availability of the add to wishlist button when viewing SKU information.
        public var isWishlistAvailable: Bool = true

        /// Controls the availability of the share buttons on generation results.
        public var isShareAvailable: Bool = true

        /// Controls the availability of taking photo from camera.
        /// If not, only phone gallery will be available.
        public var isCameraAvailable: Bool = true

        /// While waiting for the try-on result, try to highlight the human outline
        /// using iOS system tools on the animation screen . Works locally. iOS 15+.
        /// In case of failure, the normal animation of the loader will not be affected.
        public var tryGeneratePersonSegmentation: Bool = true

        /// Allow user to change photo on results page
        /// to make another tryon whithin the same product.
        public var allowContiniousTryOn: Bool = true

        /// Display a clickable message bar that results may vary from real-life fit.
        public var showFitDisclaimerOnResults: Bool = true

        /// Should ask user opinion on generations results.
        /// This options show/hide like and dislike buttons.
        public var askForUserFeedbackOnResults: Bool = true

        /// Use additional splash screen before onboarding.
        public var showSplashScreenBeforeOnboadring: Bool = false

        /// When the user closes the SDK during the generation process, the SDK can wait
        /// for the generation to complete in the background and provide the data to the host application.
        /// If disable this, the SDK will stop tracking the status of the operation and stop all activity on closing.
        /// Note that the backend will still complete the operation.
        public var allowBackgroundExecution: Bool = true

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
        public var swipeToDismissPolicy: SwipeToDismissPolicy = .allowHeaderSwipeOnly

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
    /// Defines how the SDK will be presented as modal view controller.
    public enum PresentationStyle: String, Equatable, Codable, CaseIterable {
        case pageSheet
        case bottomSheet
        case fullScreen
    }
}

extension Aiuta.Configuration.Appearance {
    public enum SwipeToDismissPolicy: String, Equatable, Codable, CaseIterable {
        case allowAlways
        case protectTheNecessary
        case allowHeaderSwipeOnly
    }
}

// MARK: - Appearance.Toggles

extension Aiuta.Configuration.Appearance {
    public struct Toggles {
        public var reduceShadows: Bool = false
        public var preferRightClose: Bool = false
        public var extendOnbordingNavBar: Bool = false
        public var applyProductFirstImageExtraInset: Bool = false
        public var enableBlurOutlines: Bool = false
    }
}
