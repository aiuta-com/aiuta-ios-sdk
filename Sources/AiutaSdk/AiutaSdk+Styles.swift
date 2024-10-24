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
        public var welcome: CustomFont?

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
