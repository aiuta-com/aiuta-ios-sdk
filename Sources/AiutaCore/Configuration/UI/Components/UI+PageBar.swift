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
    /// Page navigation bar theme configuration.
    public struct PageBarTheme: Sendable {
        /// Text style for page titles.
        public let typography: Typography
        
        /// Back and close button icons.
        public let icons: Icons
        
        /// Close button positioning settings.
        public let settings: Settings
        
        /// Creates a custom page bar theme.
        ///
        /// - Parameters:
        ///   - typography: Text style for page titles.
        ///   - icons: Back and close button icons.
        ///   - settings: Close button positioning settings.
        public init(typography: Typography,
                    icons: Icons,
                    settings: Settings) {
            self.typography = typography
            self.icons = icons
            self.settings = settings
        }
    }
}

// MARK: - Typography

extension Aiuta.Configuration.UserInterface.PageBarTheme {
    /// Typography style for page titles.
    public struct Typography: Sendable {
        /// Text style applied to page titles in the navigation bar.
        public let pageTitle: Aiuta.Configuration.TextStyle
        
        /// Creates custom typography.
        ///
        /// - Parameters:
        ///   - pageTitle: Text style applied to page titles in the navigation bar.
        public init(pageTitle: Aiuta.Configuration.TextStyle) {
            self.pageTitle = pageTitle
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.UserInterface.PageBarTheme {
    /// Navigation icons for the page bar.
    public struct Icons: Sendable {
        /// Back button icon (24x24).
        public let back24: UIImage
        
        /// Close button icon (24x24).
        public let close24: UIImage
        
        /// Creates custom navigation icons.
        ///
        /// - Parameters:
        ///   - back24: Back button icon (24x24).
        ///   - close24: Close button icon (24x24).
        public init(back24: UIImage,
                    close24: UIImage) {
            self.back24 = back24
            self.close24 = close24
        }
    }
}

// MARK: - Settings

extension Aiuta.Configuration.UserInterface.PageBarTheme {
    /// Layout settings for the page bar.
    public struct Settings: Sendable {
        /// Whether the close button should be positioned on the right side instead of the left.
        public let preferCloseButtonOnTheRight: Bool
        
        /// Creates custom layout settings.
        ///
        /// - Parameters:
        ///   - preferCloseButtonOnTheRight: Whether the close button should be positioned on the right side instead of the left.
        public init(preferCloseButtonOnTheRight: Bool) {
            self.preferCloseButtonOnTheRight = preferCloseButtonOnTheRight
        }
    }
}
