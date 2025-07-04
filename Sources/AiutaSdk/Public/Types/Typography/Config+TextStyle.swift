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

extension Aiuta.Configuration {
    /// Represents a text style configuration used throughout the SDK. This
    /// structure allows you to define the appearance of text, including its
    /// font, size, weight, and additional attributes like kerning and line
    /// height. By using this, you can ensure consistent typography between
    /// your UI components and the Aiuta SDK.
    public struct TextStyle {
        /// The font used for the text. This defines the typeface applied to
        /// the text content.
        public let font: UIFont

        /// The size of the font in points. This determines how large or small
        /// the text appears.
        public let size: CGFloat

        /// The weight of the font. This controls the thickness of the text.
        public let weight: UIFont.Weight

        /// The kerning value for the text. Kerning adjusts the spacing
        /// between characters to improve readability or achieve a specific
        /// visual effect. This is optional.
        public let kern: CGFloat?

        /// The line height multiple for the text. This value adjusts the
        /// spacing between lines of text, allowing you to control the
        /// vertical rhythm of your typography. This is optional.
        public let lineHeightMultiple: CGFloat?

        /// Initializes a new text style with the specified attributes.
        ///
        /// - Parameters:
        ///   - font: The font to use for the text.
        ///   - size: The size of the font in points. If omitted,
        ///           provided font's `pointSize` will be used.
        ///   - weight: The weight of the font.
        ///   - kern: The kerning value for character spacing (optional).
        ///   - lineHeightMultiple: The line height multiplier (optional).
        public init(font: UIFont,
                    size: CGFloat? = nil,
                    weight: UIFont.Weight,
                    kern: CGFloat? = nil,
                    lineHeightMultiple: CGFloat? = nil) {
            self.font = font
            self.size = size ?? font.pointSize
            self.weight = weight
            self.kern = kern
            self.lineHeightMultiple = lineHeightMultiple
        }

        /// Initializes a new text style with the specified attributes.
        ///
        /// - Parameters:
        ///   - font: The font to use for the text.
        ///   - size: The size of the font in points. If omitted,
        ///           provided font's `pointSize` will be used.
        ///   - weight: The weight of the font.
        ///   - kern: The kerning value for character spacing (optional).
        ///   - lineHeight: The line height (optional).
        public init(font: UIFont,
                    size: CGFloat? = nil,
                    weight: UIFont.Weight,
                    kern: CGFloat? = nil,
                    lineHeight: CGFloat? = nil) {
            self.font = font
            self.size = size ?? font.pointSize
            self.weight = weight
            self.kern = kern
            if let lineHeight, font.lineHeight > 0 {
                lineHeightMultiple = lineHeight / font.lineHeight
            } else {
                lineHeightMultiple = nil
            }
        }

        /// Initializes a new text style with the system font and specified attributes.
        ///
        /// - Parameters:
        ///   - font: The font to use for the text.
        ///   - size: The size of the font in points.
        ///   - weight: The weight of the font.
        ///   - kern: The kerning value for character spacing (optional).
        ///   - lineHeightMultiple: The line height multiplier (optional).
        public init(size: CGFloat,
                    weight: UIFont.Weight,
                    kern: CGFloat? = nil,
                    lineHeightMultiple: CGFloat? = nil) {
            font = .systemFont(ofSize: size, weight: weight)
            self.size = size
            self.weight = weight
            self.kern = kern
            self.lineHeightMultiple = lineHeightMultiple
        }

        /// Initializes a new text style with the system font and specified attributes.
        ///
        /// - Parameters:
        ///   - size: The size of the font in points.
        ///   - weight: The weight of the font.
        ///   - kern: The kerning value for character spacing (optional).
        ///   - lineHeight: The line height (optional).
        public init(size: CGFloat,
                    weight: UIFont.Weight,
                    kern: CGFloat? = nil,
                    lineHeight: CGFloat? = nil) {
            font = .systemFont(ofSize: size, weight: weight)
            self.size = size
            self.weight = weight
            self.kern = kern
            if let lineHeight, font.lineHeight > 0 {
                lineHeightMultiple = lineHeight / font.lineHeight
            } else {
                lineHeightMultiple = nil
            }
        }
    }
}
