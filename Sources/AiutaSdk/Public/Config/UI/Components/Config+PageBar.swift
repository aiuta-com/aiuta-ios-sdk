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
    /// Configures the page (navigation) bar theme for the SDK.
    ///
    /// This setting determines the appearance and behavior of the page bar.
    /// You can use the default theme or define a custom one to align with your application's design and functionality.
    public enum PageBarTheme {
        /// Use the default page bar theme provided by the SDK.
        case `default`

        /// Define a custom page bar theme.
        ///
        /// - Parameters:
        ///   - typography: Specifies the typography to use for page bar text.
        ///   - icons: Specifies the icons to use for page bar views.
        ///   - settings: Configures the behavior and layout of the page bar.
        case custom(typography: Typography = .default,
                    icons: Icons = .builtIn,
                    settings: Settings = .default)
    }
}

// MARK: - Typography

extension Aiuta.Configuration.UserInterface.PageBarTheme {
    /// Configures the typography used for page bar text.
    ///
    /// Typography defines the text styles applied to page bar elements, such as font size and weight. You can use the default typography or define custom styles to match your application's design language.
    public enum Typography {
        /// Use the default typography provided by the SDK.
        case `default`

        /// Define custom typography for page bar text.
        ///
        /// - Parameters:
        ///   - pageTitle: The text style to apply to page titles.
        case custom(pageTitle: Aiuta.Configuration.TextStyle)

        /// Use a custom typography provider.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom typography.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.PageBarTheme.Typography {
    /// A protocol for supplying custom typography for page bar themes.
    ///
    /// This protocol defines the required text styles for page titles. It is intended for internal use. Instead of implementing this protocol directly, you can use one of the predefined typography options or provide a custom implementation.
    /// - Note: Use the `Aiuta.Configuration.Typography` typealias for convenience.
    public protocol Provider {
        /// The text style to apply to page titles.
        var pageTitle: Aiuta.Configuration.TextStyle { get }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.UserInterface.PageBarTheme {
    /// Configures the icons used for page bar views.
    ///
    /// Icons are displayed in the page bar for actions like navigation or closing a page. You can use the default icons provided by the SDK or define custom ones to better align with your application's branding.
    public enum Icons {
        /// Use the default icons built into the SDK.
        case builtIn

        /// Define custom icons for page bar views.
        ///
        /// - Parameters:
        ///   - back24: The icon to display for the back button.
        ///   - close24: The icon to display for the close button.
        case custom(back24: UIImage,
                    close24: UIImage)

        /// Use a custom icons provider.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom icons.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.PageBarTheme.Icons {
    /// A protocol for supplying custom icons for page bar themes.
    ///
    /// This protocol defines the required icons for the back and close buttons.
    /// - Note: It is intended for internal use. Instead of implementing this protocol directly,
    ///         use the `Aiuta.Configuration.Icons` typealias for convenience.
    public protocol Provider {
        /// The icon to display for the back button.
        var back24: UIImage { get }

        /// The icon to display for the close button.
        var close24: UIImage { get }
    }
}

// MARK: - Settings

extension Aiuta.Configuration.UserInterface.PageBarTheme {
    /// Configures the layout settings for the page bar.
    ///
    /// These settings allow you to control specific position of the close button.
    public enum Settings {
        /// Use the default page bar settings provided by the SDK.
        case `default`

        /// Define custom settings for the page bar.
        ///
        /// - Parameters:
        ///   - preferCloseButtonOnTheRight: A toggle to specify whether the close button should be positioned on the right side.
        case custom(preferCloseButtonOnTheRight: Bool)
    }
}
