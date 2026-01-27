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
    /// Activity indicator theme configuration.
    public struct ActivityIndicatorTheme: Sendable {
        /// Icon configuration for the activity indicator.
        public let icons: Icons
        
        /// Color scheme for the activity indicator.
        public let colors: Colors
        
        /// Behavior and animation settings.
        public let settings: Settings
        
        /// Creates a custom activity indicator theme.
        ///
        /// - Parameters:
        ///   - icons: Icon configuration for the activity indicator.
        ///   - colors: Color scheme for the activity indicator.
        ///   - settings: Behavior and animation settings.
        public init(icons: Icons,
                    colors: Colors,
                    settings: Settings) {
            self.icons = icons
            self.colors = colors
            self.settings = settings
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.UserInterface.ActivityIndicatorTheme {
    /// Icon configuration for the activity indicator.
    public struct Icons: Sendable {
        /// The icon for the 14px loading indicator.
        public let loading14: UIImage
        
        /// Creates custom icon configuration.
        ///
        /// - Parameters:
        ///   - loading14: The icon for the 14px loading indicator.
        public init(loading14: UIImage) {
            self.loading14 = loading14
        }
    }
}

// MARK: - Colors

extension Aiuta.Configuration.UserInterface.ActivityIndicatorTheme {
    /// Color scheme for the activity indicator.
    public struct Colors: Sendable {
        /// The overlay color.
        public let overlay: UIColor
        
        /// Creates custom color configuration.
        ///
        /// - Parameters:
        ///   - overlay: The overlay color.
        public init(overlay: UIColor) {
            self.overlay = overlay
        }
    }
}

// MARK: - Settings

extension Aiuta.Configuration.UserInterface.ActivityIndicatorTheme {
    /// Behavior and animation settings for the activity indicator.
    public struct Settings: Sendable {
        /// The delay before showing the indicator (in milliseconds).
        public let indicationDelay: Int
        
        /// The duration of the spin animation (in milliseconds).
        public let spinDuration: Int
        
        /// Creates custom settings configuration.
        ///
        /// - Parameters:
        ///   - indicationDelay: The delay before showing the indicator (in milliseconds).
        ///   - spinDuration: The duration of the spin animation (in milliseconds).
        public init(indicationDelay: Int,
                    spinDuration: Int) {
            self.indicationDelay = indicationDelay
            self.spinDuration = spinDuration
        }
    }
}
