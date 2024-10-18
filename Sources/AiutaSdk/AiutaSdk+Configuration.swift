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
        public var extendedOnbordingNavBar: Bool = false
        public var preferRightClose: Bool = false
        public var reduceShadows: Bool = false

        /// The language in which the SDK interface will be displayed.
        /// If not specified, the first preferred system language will be used
        /// if it is supported, otherwise English will be used.
        public var language: Language?

        public var colors = Colors()
        public var dimensions = Dimensions()
        public var fonts = Fonts()
        public var images = Images()
    }
}

// MARK: - Appearance.Manguage

extension Aiuta.Configuration.Appearance {
    /// The language in which the SDK should be displayed.
    public enum Language: Equatable {
        case English, Turkish, Russian
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

// MARK: - Appearance.Color

extension Aiuta.Configuration.Appearance {
    public enum Style {
        case light, dark
    }

    /// Color overrides
    public struct Colors {
        public var style: Style = .light

        /// Your brand's primary color.
        /// This color will be used for all significant interface elements,
        /// such as the main action button on the screen, progress bars, etc.
        public var brand: UIColor?

        /// Extra special attention color. The discounted price labels
        /// and the discount percentage background will be colored in it.
        public var accent: UIColor?
        public var aiuta: UIColor?

        public var primary: UIColor?
        public var secondary: UIColor?
        public var tertiary: UIColor?
        public var onDark: UIColor?

        public var error: UIColor?
        public var onError: UIColor?

        /// The background color of all screens.
        public var background: UIColor?
        public var neutral: UIColor?
        public var neutral2: UIColor?
        public var neutral3: UIColor?

        public var green: UIColor?
        public var red: UIColor?
        public var gray: UIColor?
        public var lightGray: UIColor?
        public var darkGray: UIColor?

        public var loadingAnimation: [UIColor]?

        public init() {}
    }
}

// MARK: - Appearance.Dimesions

extension Aiuta.Configuration.Appearance {
    /// Varios corner radiuses, sizes, offsets, etc.
    public struct Dimensions {
        public var imageMainRadius: CGFloat?
        public var imageBoardingRadius: CGFloat?
        public var imagePreviewRadius: CGFloat?

        public var bottomSheetRadius: CGFloat?

        public var buttonLargeRadius: CGFloat?
        public var buttonSmallRadius: CGFloat?

        public var grabberWidth: CGFloat?
        public var grabberOffset: CGFloat?

        public var continuingSeparators: Bool?

        public init() {}
    }
}

// MARK: - Appearance.Fonts

extension Aiuta.Configuration.Appearance {
    /// Custom fonts
    public struct Fonts {
        public var titleXL: CustomFont?
        public var titleL: CustomFont?
        public var titleM: CustomFont?

        public var navBar: CustomFont?
        public var regular: CustomFont?
        public var button: CustomFont?
        public var buttonS: CustomFont?

        public var cells: CustomFont?
        public var chips: CustomFont?

        public var product: CustomFont?
        public var price: CustomFont?
        public var brand: CustomFont?

        public var description: CustomFont?

        public init() {}
    }

    public struct CustomFont {
        public let font: UIFont
        public let family: String
        public let size: CGFloat
        public let weight: UIFont.Weight
        public var kern: CGFloat?
        public var lineHeightMultiple: CGFloat?

        public init(font: UIFont, family: String, size: CGFloat, weight: UIFont.Weight, kern: CGFloat? = nil, lineHeightMultiple: CGFloat? = nil) {
            self.font = font
            self.family = family
            self.size = size
            self.weight = weight
            self.kern = kern
            self.lineHeightMultiple = lineHeightMultiple
        }
    }
}

// MARK: - Appearance.Images

extension Aiuta.Configuration.Appearance {
    /// Image overrides
    public struct Images {
        public var icons16 = Icons16()
        public var icons20 = Icons20()
        public var icons24 = Icons24()
        public var icons36 = Icons36()
        public var icons82 = Icons82()
        public var screens = Screens()

        public init() {}
    }
}

extension Aiuta.Configuration.Appearance.Images {
    public struct Icons16 {
        public var check: UIImage?
        public var magic: UIImage?
        public var lock: UIImage?
        public var arrow: UIImage?
        public var spin: UIImage?
    }

    public struct Icons20 {
        public var info: UIImage?
    }

    public struct Icons24 {
        public var back: UIImage?
        public var camera: UIImage?
        public var checkCorrect: UIImage?
        public var checkNotCorrect: UIImage?
        public var close: UIImage?
        public var trash: UIImage?
        public var takePhoto: UIImage?
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
    }

    public struct Icons82 {
        public var splash: UIImage?
    }

    public struct Screens {
        public var splash: UIImage?
    }
}
