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
    /// Configures the theme for the selection snackbar.
    ///
    /// This setting determines how the selection snackbar looks and behaves. You can
    /// use the default theme or define a custom one to better align with your app's
    /// design and functionality.
    public enum SelectionSnackbarTheme {
        /// Use the default selection snackbar theme provided by the SDK.
        case `default`

        /// Define a custom selection snackbar theme.
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

extension Aiuta.Configuration.UserInterface.SelectionSnackbarTheme {
    /// Configures the text strings used in the selection snackbar.
    ///
    /// Strings define the text displayed for actions like "select" or "cancel." You
    /// can use the default strings or define custom ones to better match your app's
    /// language and tone.
    public enum Strings {
        /// Use the default strings provided by the SDK.
        case `default`

        /// Define custom strings for the selection snackbar.
        ///
        /// - Parameters:
        ///   - select: The text for the "select" action.
        ///   - cancel: The text for the "cancel" action.
        ///   - selectAll: The text for the "select all" action.
        ///   - unselectAll: The text for the "unselect all" action.
        case custom(select: String,
                    cancel: String,
                    selectAll: String,
                    unselectAll: String)

        /// Use a custom strings provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom strings.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.SelectionSnackbarTheme.Strings {
    /// Supplies custom strings for the selection snackbar theme.
    ///
    /// This protocol defines the required text for actions like "select" and "cancel."
    /// - Note: Use the `Aiuta.Configuration.Strings` typealias for convenience.
    public protocol Provider {
        /// The text for the "select" action.
        var select: String { get }

        /// The text for the "cancel" action.
        var cancel: String { get }

        /// The text for the "select all" action.
        var selectAll: String { get }

        /// The text for the "unselect all" action.
        var unselectAll: String { get }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.UserInterface.SelectionSnackbarTheme {
    /// Configures the icons displayed in the selection snackbar.
    ///
    /// Icons visually represent actions like "trash" or "check." You can use the
    /// default icons or define custom ones to align with your app's branding.
    public enum Icons {
        /// Use the default icons built into the SDK.
        case builtIn

        /// Define custom icons for the selection snackbar.
        ///
        /// - Parameters:
        ///   - trash24: The icon for the delete action.
        ///   - check20: The icon for the selected item state.
        case custom(trash24: UIImage,
                    check20: UIImage)

        /// Use a custom icons provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom icons.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.SelectionSnackbarTheme.Icons {
    /// Supplies custom icons for the selection snackbar theme.
    ///
    /// This protocol defines the required icons for delete action and selected item states.
    /// - Note: Use the `Aiuta.Configuration.Icons` typealias for convenience.
    public protocol Provider {
        /// The icon for the delete action.
        var trash24: UIImage { get }

        /// The icon for the selected item state.
        var check20: UIImage { get }
    }
}

// MARK: - Colors

extension Aiuta.Configuration.UserInterface.SelectionSnackbarTheme {
    /// Configures the color scheme for the selection snackbar.
    ///
    /// Colors define the visual style of the snackbar, such as its background color.
    /// You can use the default color scheme or define custom colors to match your
    /// app's design language.
    public enum Colors {
        /// Use the default color scheme provided by the SDK.
        case aiutaLight

        /// Define custom colors for the selection snackbar.
        ///
        /// - Parameters:
        ///   - selectionBackground: The background color for the snackbar.
        case custom(selectionBackground: UIColor)

        /// Use a custom colors provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom colors.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.SelectionSnackbarTheme.Colors {
    /// Supplies custom colors for the selection snackbar theme.
    ///
    /// This protocol defines the required colors, such as the background color.
    /// - Note: Use the `Aiuta.Configuration.Colors` typealias for convenience.
    public protocol Provider {
        /// The background color for the selection snackbar.
        var selectionBackground: UIColor { get }
    }
}
