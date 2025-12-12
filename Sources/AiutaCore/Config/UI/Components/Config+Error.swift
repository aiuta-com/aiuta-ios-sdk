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
    /// Configures the theme for the error snackbar.
    ///
    /// This setting determines how the error snackbar looks and behaves. You can
    /// use the default theme or define a custom one to better align with your app's
    /// design and functionality.
    public enum ErrorSnackbarTheme {
        /// Use the default error snackbar theme provided by the SDK.
        case `default`

        /// Define a custom error snackbar theme.
        ///
        /// - Parameters:
        ///   - strings: Configures the text strings used in the snackbar.
        ///   - icons: Configures the icons displayed in the snackbar.
        ///   - colors: Configures the color scheme for the snackbar.
        case custom(strings: Strings = .default,
                    icons: Icons = .builtIn,
                    colors: Colors = .aiutaLight)
    }
}

// MARK: - Strings

extension Aiuta.Configuration.UserInterface.ErrorSnackbarTheme {
    /// Configures the text strings used in the error snackbar.
    ///
    /// Strings define the text displayed for actions like error messages or retry
    /// buttons. You can use the default strings or define custom ones to better
    /// match your app's language and tone.
    public enum Strings {
        /// Use the default strings provided by the SDK.
        case `default`

        /// Define custom strings for the error snackbar.
        ///
        /// - Parameters:
        ///   - defaultErrorMessage: The default error message string.
        ///   - tryAgainButton: The text for the "try again" button.
        case custom(defaultErrorMessage: String,
                    tryAgainButton: String)

        /// Use a custom strings provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom strings.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.ErrorSnackbarTheme.Strings {
    /// Supplies custom strings for the error snackbar theme.
    ///
    /// This protocol defines the required text for error messages and retry actions.
    /// - Note: Use the `Aiuta.Configuration.Strings` typealias for convenience.
    public protocol Provider {
        /// The default error message string.
        var defaultErrorMessage: String { get }

        /// The text for the "try again" button.
        var tryAgainButton: String { get }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.UserInterface.ErrorSnackbarTheme {
    /// Configures the icons displayed in the error snackbar.
    ///
    /// Icons visually represent the error state. You can use the default icons or
    /// define custom ones to align with your app's branding.
    public enum Icons {
        /// Use the default icons built into the SDK.
        case builtIn

        /// Define custom icons for the error snackbar.
        ///
        /// - Parameters:
        ///   - error36: The icon for the error state.
        case custom(error36: UIImage)

        /// Use a custom icons provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom icons.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.ErrorSnackbarTheme.Icons {
    /// Supplies custom icons for the error snackbar theme.
    ///
    /// This protocol defines the required icons for the error state.
    /// - Note: Use the `Aiuta.Configuration.Icons` typealias for convenience.
    public protocol Provider {
        /// The icon for the error state.
        var error36: UIImage { get }
    }
}

// MARK: - Colors

extension Aiuta.Configuration.UserInterface.ErrorSnackbarTheme {
    /// Configures the color scheme for the error snackbar.
    ///
    /// Colors define the visual style of the snackbar, such as its background and
    /// primary colors. You can use the default color scheme or define custom colors
    /// to match your app's design language.
    public enum Colors {
        /// Use the default error snackbar colors provided by the SDK.
        case aiutaLight

        /// Define custom colors for the error snackbar.
        ///
        /// - Parameters:
        ///   - errorBackground: The background color for the snackbar.
        ///   - errorPrimary: The primary color for the snackbar.
        case custom(errorBackground: UIColor,
                    errorPrimary: UIColor)

        /// Use a custom colors provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom colors.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.ErrorSnackbarTheme.Colors {
    /// Supplies custom colors for the error snackbar theme.
    ///
    /// This protocol defines the required colors, such as the background and primary
    /// colors.
    /// - Note: Use the `Aiuta.Configuration.Colors` typealias for convenience.
    public protocol Provider {
        /// The background color for the error snackbar.
        var errorBackground: UIColor { get }

        /// The primary color for the error snackbar.
        var errorPrimary: UIColor { get }
    }
}
