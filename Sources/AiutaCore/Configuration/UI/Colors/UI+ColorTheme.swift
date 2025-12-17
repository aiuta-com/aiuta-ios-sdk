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
    /// Configures the color theme for the SDK.
    ///
    /// You can choose from predefined themes or create a fully customized theme to align
    /// the SDK's design with your application's branding and style.
    public enum ColorTheme: Sendable {
        /// Uses the default light color theme provided by the Aiuta SDK.
        case `default`
        
        /// Uses the default color theme provided by the Aiuta SDK.
        ///
        /// - Parameters:
        ///   - scheme: Specifies whether the theme should use a light or dark color scheme.
        case aiuta(scheme: ColorScheme)

        /// Uses the default color theme with a custom brand color.
        ///
        /// This option allows you to specify a custom brand color, which is used for primary
        /// action buttons and other key highlights. This helps the SDK better align with
        /// your application's visual identity.
        ///
        /// - Parameters:
        ///   - scheme: Specifies whether the theme should use a light or dark color scheme.
        ///   - color: The main accent color of your application, used for primary actions
        ///            and highlights throughout the SDK.
        case brand(scheme: ColorScheme,
                   color: UIColor)

        /// Uses a fully customized color theme.
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
        case custom(
            scheme: ColorScheme,
            brand: UIColor,
            primary: UIColor,
            secondary: UIColor,
            onDark: UIColor,
            onLight: UIColor,
            background: UIColor,
            screen: UIColor?,
            neutral: UIColor,
            border: UIColor,
            outline: UIColor)

        /// Uses a custom color provider to define the theme.
        ///
        /// This option allows you to supply a custom implementation of the `Provider` protocol,
        /// which defines the color palette for the SDK.
        ///
        /// - Parameters:
        ///   - provider: An object conforming to the `Provider` protocol that supplies
        ///               the custom colors for the SDK.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.ColorTheme {
    /// A protocol for providing a custom color theme for the Aiuta SDK.
    ///
    /// This protocol defines the properties required to specify a complete color palette
    /// for the SDK. It is intended for internal use only and should not be implemented
    /// directly. Instead, use the `Aiuta.Configuration.Colors` typealias.
    public protocol Provider: Sendable {
        /// Specifies whether the theme uses a light or dark color scheme.
        /// The provided colors should match the selected scheme.
        var scheme: Aiuta.Configuration.UserInterface.ColorScheme { get }

        /// The main accent color of your application.
        var brand: UIColor { get }

        /// The color used for primary text elements.
        var primary: UIColor { get }

        /// The color used for secondary text elements.
        var secondary: UIColor { get }

        /// Preferably light color in any scheme to be used on dark, brand and neutral backgrounds.
        var onDark: UIColor { get }

        /// Preferably dark color in any scheme to be used on light backgrounds.
        var onLight: UIColor { get }

        /// The main background color of the SDK and bottom sheets.
        var background: UIColor { get }

        /// The background color for zero-elevation screens.
        /// For full-screen mode, this color is used as a background color.
        /// Bottom sheets inside the SDK will still use the `background` color.
        ///
        /// If not provided, the `background` color will be used.
        var screen: UIColor? { get }

        /// A neutral background color used for components.
        var neutral: UIColor { get }

        /// The color used for component borders.
        var border: UIColor { get }

        /// The color used for blur outlines and checkmark borders.
        var outline: UIColor { get }
    }
}
