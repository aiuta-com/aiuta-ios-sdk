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
    /// Configures the button theme for the SDK.
    ///
    /// This setting determines the appearance of buttons within the SDK.
    /// You can use the default button theme or define a custom one to align with your application's design and branding.
    public enum ButtonTheme {
        /// Use the default button theme provided by the SDK.
        case `default`

        /// Define a custom button theme.
        ///
        /// - Parameters:
        ///   - typography: Specifies the typography to use for button text.
        ///   - shapes: Specifies the shapes to apply to button views.
        case custom(typography: Typography = .default,
                    shapes: Shapes = .default)
    }
}

// MARK: - Shapes

extension Aiuta.Configuration.UserInterface.ButtonTheme {
    /// Configures the shapes used for button views.
    ///
    /// Shapes define the visual appearance of button containers, such as rounded corners or specific geometric styles.
    /// You can use predefined shapes or define custom ones to match your application's design language.
    public enum Shapes {
        /// Use the default button shapes provided by the SDK.
        case `default`

        /// Use button shapes with smaller corner radius.
        case small

        /// Define custom shapes for button views.
        ///
        /// - Parameters:
        ///   - buttonM: The shape to apply to medium buttons.
        ///   - buttonS: The shape to apply to small buttons.
        case custom(buttonM: Aiuta.Configuration.Shape,
                    buttonS: Aiuta.Configuration.Shape)

        /// Use a custom shapes provider.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom shapes.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.ButtonTheme.Shapes {
    /// A protocol for supplying custom shapes for button themes.
    ///
    /// This protocol defines the required shapes for medium and small buttons.
    /// - Note: It is intended for internal use. Instead of implementing this protocol directly,
    ///         use one of `Aiuta.Configuration.Shapes` typealias.
    public protocol Provider {
        /// The shape to apply to medium buttons.
        var buttonM: Aiuta.Configuration.Shape { get }

        /// The shape to apply to small buttons.
        var buttonS: Aiuta.Configuration.Shape { get }
    }
}

// MARK: - Typography

extension Aiuta.Configuration.UserInterface.ButtonTheme {
    /// Configures the typography used for button text.
    ///
    /// Typography defines the text styles applied to buttons, such as font size and weight.
    /// You can use the default typography or define custom styles to match your application's design language.
    public enum Typography {
        /// Use the default button typography provided by the SDK.
        case `default`

        /// Define custom typography for button text.
        ///
        /// - Parameters:
        ///   - buttonM: The text style to apply to medium buttons.
        ///   - buttonS: The text style to apply to small buttons.
        case custom(buttonM: Aiuta.Configuration.TextStyle,
                    buttonS: Aiuta.Configuration.TextStyle)

        /// Use a custom typography provider.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom typography.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.ButtonTheme.Typography {
    /// A protocol for supplying custom typography for button themes.
    ///
    /// This protocol defines the required text styles for medium and small buttons.
    /// - Note: It is intended for internal use. Instead of implementing this protocol directly,
    ///         use one of `Aiuta.Configuration.Typography` typealias.
    public protocol Provider {
        /// The text style to apply to medium buttons.
        var buttonM: Aiuta.Configuration.TextStyle { get }

        /// The text style to apply to small buttons.
        var buttonS: Aiuta.Configuration.TextStyle { get }
    }
}
