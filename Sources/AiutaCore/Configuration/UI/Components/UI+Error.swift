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
    /// Error snackbar theme configuration.
    public struct ErrorSnackbarTheme: Sendable {
        /// Text strings used in the snackbar.
        public let strings: Strings
        
        /// Icons displayed in the snackbar.
        public let icons: Icons
        
        /// Color scheme for the snackbar.
        public let colors: Colors
        
        /// Creates a custom error snackbar theme.
        ///
        /// - Parameters:
        ///   - strings: Text strings used in the snackbar.
        ///   - icons: Icons displayed in the snackbar.
        ///   - colors: Color scheme for the snackbar.
        public init(strings: Strings,
                    icons: Icons,
                    colors: Colors) {
            self.strings = strings
            self.icons = icons
            self.colors = colors
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.UserInterface.ErrorSnackbarTheme {
    /// Text strings configuration for the error snackbar.
    public struct Strings: Sendable {
        /// The default error message string.
        public let defaultErrorMessage: String
        
        /// The text for the "try again" button.
        public let tryAgainButton: String
        
        /// Creates custom strings configuration.
        ///
        /// - Parameters:
        ///   - defaultErrorMessage: The default error message string.
        ///   - tryAgainButton: The text for the "try again" button.
        public init(defaultErrorMessage: String,
                    tryAgainButton: String) {
            self.defaultErrorMessage = defaultErrorMessage
            self.tryAgainButton = tryAgainButton
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.UserInterface.ErrorSnackbarTheme {
    /// Icon configuration for the error snackbar.
    public struct Icons: Sendable {
        /// The icon for the error state.
        public let error36: UIImage
        
        /// Creates custom icon configuration.
        ///
        /// - Parameters:
        ///   - error36: The icon for the error state.
        public init(error36: UIImage) {
            self.error36 = error36
        }
    }
}

// MARK: - Colors

extension Aiuta.Configuration.UserInterface.ErrorSnackbarTheme {
    /// Color scheme for the error snackbar.
    public struct Colors: Sendable {
        /// The background color for the snackbar.
        public let errorBackground: UIColor
        
        /// The primary color for the snackbar.
        public let errorPrimary: UIColor
        
        /// Creates custom color configuration.
        ///
        /// - Parameters:
        ///   - errorBackground: The background color for the snackbar.
        ///   - errorPrimary: The primary color for the snackbar.
        public init(errorBackground: UIColor,
                    errorPrimary: UIColor) {
            self.errorBackground = errorBackground
            self.errorPrimary = errorPrimary
        }
    }
}
