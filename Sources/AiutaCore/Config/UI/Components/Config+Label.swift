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
    /// Configures the label theme for the SDK.
    ///
    /// This setting allows you to use the default label theme or define a custom one
    /// to better align with your application's design and typography.
    public enum LabelTheme {
        /// Use the default label theme provided by the SDK.
        case `default`

        /// Define a custom label theme.
        ///
        /// - Parameters:
        ///   - typography: Specifies the typography to use for label text.
        case custom(typography: Typography = .default)
    }
}

extension Aiuta.Configuration.UserInterface.LabelTheme {
    /// Configures the typography for label text.
    ///
    /// This setting allows you to use the default typography or define custom styles
    /// for different text elements, such as titles and regular text.
    public enum Typography {
        /// Use the default typography provided by the SDK.
        case `default`

        /// Define custom typography for label text.
        ///
        /// - Parameters:
        ///   - titleL: The text style for large titles.
        ///   - titleM: The text style for medium titles.
        ///   - regular: The text style for regular text.
        ///   - subtle: The text style for subtle text.
        case custom(titleL: Aiuta.Configuration.TextStyle,
                    titleM: Aiuta.Configuration.TextStyle,
                    regular: Aiuta.Configuration.TextStyle,
                    subtle: Aiuta.Configuration.TextStyle)

        /// Use a custom typography provider.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom typography.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.LabelTheme.Typography {
    /// A protocol for providing custom typography for label themes.
    ///
    /// This protocol defines the required text styles for large titles, medium titles,
    /// regular text, and subtle text.
    /// - Note: Avoid using this protocol directly. It is intended for internal use only.
    ///         Use one of `Aiuta.Configuration.Typography` protocol instead.
    public protocol Provider {
        /// The text style for large titles.
        var titleL: Aiuta.Configuration.TextStyle { get }

        /// The text style for medium titles.
        var titleM: Aiuta.Configuration.TextStyle { get }

        /// The text style for regular text.
        var regular: Aiuta.Configuration.TextStyle { get }

        /// The text style for subtle text.
        var subtle: Aiuta.Configuration.TextStyle { get }
    }
}
