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

extension Aiuta.Configuration.UserInterface {
    /// Defines the color scheme for the SDK's user interface.
    ///
    /// This setting determines whether the SDK uses a light or dark theme. It affects
    /// the appearance of system screens (e.g., photo gallery, share activity, etc.) and
    /// ensures that their `UIUserInterfaceStyle` matches the selected style. For example,
    /// if the SDK is set to a light theme but the system theme on the device is dark,
    /// the system windows invoked by the SDK will still use the light theme.
    ///
    /// Additionally, this setting influences the style of blur components and the tint
    /// applied to recolored icons within the SDK.
    public enum ColorScheme: Sendable {
        /// A light theme, characterized by a predominance of light colors in the design.
        case light
        /// A dark theme, characterized by a predominance of dark colors in the design.
        case dark
    }
}

extension Aiuta.Configuration.UserInterface {
    /// Color theme configuration for the SDK.
    public struct ColorTheme: Sendable {
        /// Light or dark color scheme affecting system screens and blur components.
        public let scheme: ColorScheme
        
        /// Main accent color for primary action buttons and highlights.
        public let brand: UIColor
        
        /// Color for primary text elements.
        public let primary: UIColor
        
        /// Color for secondary text elements.
        public let secondary: UIColor
        
        /// Light color to use on dark, brand, and neutral backgrounds.
        public let onDark: UIColor
        
        /// Dark color to use on light backgrounds.
        public let onLight: UIColor
        
        /// Main background color for the SDK and bottom sheets.
        public let background: UIColor
        
        /// Background color for full-screen mode.
        /// Bottom sheets will still use the `background` color.
        /// If not provided, the `background` color will be used.
        public let screen: UIColor?
        
        /// Neutral background color for UI components.
        public let neutral: UIColor
        
        /// Border color for UI components.
        public let border: UIColor
        
        /// Color for blur outlines and checkmark borders.
        public let outline: UIColor
        
        /// Creates a fully customized color theme.
        ///
        /// This option provides maximum flexibility, allowing you to define every aspect
        /// of the SDK's color palette. It is ideal for applications that require a highly
        /// tailored design to match their branding.
        ///
        /// - Parameters:
        ///   - scheme: Specifies whether the theme should use a light or dark color scheme.
        ///   - brand: The main accent color of your application, used for primary actions
        ///            and highlights throughout the SDK.
        ///   - primary: The color used for primary text elements.
        ///   - secondary: The color used for secondary text elements.
        ///   - onDark: A light color used on dark, brand, and neutral backgrounds.
        ///   - onLight: A dark color used on light backgrounds.
        ///   - background: The main background color of the SDK.
        ///   - screen: For full-screen mode, this color is used as a background color.
        ///             Bottom sheets inside the SDK will still use the `background` color.
        ///             If not provided, the `background` color will be used.
        ///   - neutral: A neutral background color used for components.
        ///   - border: The color used for component borders.
        ///   - outline: The color used for blur outlines and checkmark borders.
        public init(scheme: ColorScheme,
                    brand: UIColor,
                    primary: UIColor,
                    secondary: UIColor,
                    onDark: UIColor,
                    onLight: UIColor,
                    background: UIColor,
                    screen: UIColor?,
                    neutral: UIColor,
                    border: UIColor,
                    outline: UIColor) {
            self.scheme = scheme
            self.brand = brand
            self.primary = primary
            self.secondary = secondary
            self.onDark = onDark
            self.onLight = onLight
            self.background = background
            self.screen = screen
            self.neutral = neutral
            self.border = border
            self.outline = outline
        }
    }
}
