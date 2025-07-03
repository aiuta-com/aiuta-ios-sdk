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
    /// Configures the bottom sheet theme.
    ///
    /// This setting determines the appearance and behavior of bottom sheets.
    /// You can use the default theme or define a custom one to align with your application's design and functionality.
    public enum BottomSheetTheme {
        /// Use the default bottom sheet theme provided by the SDK.
        case `default`

        /// Define a custom bottom sheet theme.
        ///
        /// - Parameters:
        ///   - typography: Configures the typography for text elements in the bottom sheet.
        ///   - shapes: Configures the shapes for visual elements in the bottom sheet.
        ///   - grabber: Customizes the grabber's appearance or disables it.
        ///   - settings: Adjusts the behavior and layout of the bottom sheet.
        case custom(typography: Typography = .default,
                    shapes: Shapes = .default,
                    grabber: Grabber = .default,
                    settings: Settings = .default)
    }
}

// MARK: - Typography

extension Aiuta.Configuration.UserInterface.BottomSheetTheme {
    /// Configures the typography for text elements in the bottom sheet.
    ///
    /// Typography defines the text styles applied to various elements, such as buttons.
    /// You can use the default typography or define custom styles to match your application's design language.
    public enum Typography {
        /// Use the default typography provided by the SDK.
        case `default`

        /// Define custom typography for bottom sheet text.
        ///
        /// - Parameters:
        ///   - iconButton: The text style for icon buttons.
        case custom(iconButton: Aiuta.Configuration.TextStyle)

        /// Use a custom typography provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom typography.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.BottomSheetTheme.Typography {
    /// A protocol for supplying custom typography for bottom sheet themes.
    ///
    /// This protocol defines the required text styles for icon and chips buttons.
    /// - Note: Instead of implementing this protocol directly, use one of
    ///         `Aiuta.Configuration.Typography` typealias.
    public protocol Provider {
        /// The text style for icon buttons.
        var iconButton: Aiuta.Configuration.TextStyle { get }
    }
}

// MARK: - Shapes

extension Aiuta.Configuration.UserInterface.BottomSheetTheme {
    /// Configures the shapes for visual elements in the bottom sheet.
    ///
    /// Shapes define the appearance of elements like the bottom sheet container or buttons.
    /// You can use predefined shapes or define custom ones to align with your application's design language.
    public enum Shapes {
        /// Use the default shapes provided by the SDK.
        case `default`

        /// Define custom shapes for bottom sheet elements.
        ///
        /// - Parameters:
        ///   - bottomSheet: The shape for the bottom sheet container.
        case custom(bottomSheet: Aiuta.Configuration.Shape)

        /// Use a custom shapes provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom shapes.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.BottomSheetTheme.Shapes {
    /// A protocol for supplying custom shapes for bottom sheet themes.
    ///
    /// This protocol defines the required shapes for the bottom sheet container and chips buttons.
    /// - Note: Instead of implementing this protocol directly, use one of
    ///         `Aiuta.Configuration.Shapes` typealias.
    public protocol Provider {
        /// The shape for the bottom sheet container.
        var bottomSheet: Aiuta.Configuration.Shape { get }
    }
}

// MARK: - Grabber

extension Aiuta.Configuration.UserInterface.BottomSheetTheme {
    /// Configures the grabber for the bottom sheet.
    ///
    /// The grabber is a visual indicator that allows users to drag the bottom sheet.
    ///  You can use the default grabber, disable it, or define a custom one.
    public enum Grabber {
        /// Use the default grabber provided by the SDK.
        case `default`

        /// Disable the grabber.
        case none

        /// Define a custom grabber.
        ///
        /// - Parameters:
        ///   - width: The width of the grabber.
        ///   - height: The height of the grabber.
        ///   - offset: The vertical offset of the grabber from the top of the bottom sheet.
        case custom(width: CGFloat,
                    height: CGFloat,
                    offset: CGFloat)
    }
}

// MARK: - Settings

extension Aiuta.Configuration.UserInterface.BottomSheetTheme {
    /// Configures delimiters for the bottom sheet.
    ///
    /// Delimiters define the visual boundaries of the bottom sheet, such as insets or extensions to the edges.
    public enum Delimieters {
        /// Use the default inset for delimiters.
        case defaultInset

        /// Extend delimiters to the right edge of the sheet.
        case extendToTheRight

        /// Extend delimiters to both edges of the sheet.
        case extendToTheLeftAndRight
    }

    /// Configures the behavior and layout of the bottom sheet.
    ///
    /// These settings allow you to adjust specific aspects of the bottom sheet, such as delimiter positioning.
    public enum Settings {
        /// Use the default settings provided by the SDK.
        case `default`

        /// Use preset settings for delimiters.
        ///
        /// - Parameters:
        ///   - delimiters: The delimiter preset to use.
        case presets(delimiters: Delimieters)

        /// Define custom settings for the bottom sheet.
        ///
        /// - Parameters:
        ///   - extendDelimitersToTheRight: Whether to extend delimiters to the right edge.
        ///   - extendDelimitersToTheLeft: Whether to extend delimiters to the left edge.
        case custom(extendDelimitersToTheRight: Bool,
                    extendDelimitersToTheLeft: Bool)
    }
}
