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
    /// Configures the activity indicator theme.
    ///
    /// This setting determines the appearance and behavior of activity indicators.
    /// You can use the system activity indicator or define a custom one to align
    /// with your application's design and functionality.
    public enum ActivityIndicatorTheme {
        /// Use the system activity indicator with default settings.
        case `default`

        /// Define a custom activity indicator theme.
        ///
        /// - Parameters:
        ///   - icons: Configures the icons for the activity indicator.
        ///   - colors: Configures the colors for the activity indicator.
        ///   - settings: Adjusts the behavior and animation of the activity indicator.
        case custom(icons: Icons = .system,
                    colors: Colors = .default,
                    settings: Settings = .default)
    }
}

// MARK: - Icons

extension Aiuta.Configuration.UserInterface.ActivityIndicatorTheme {
    /// Configures the icons for the activity indicator.
    public enum Icons {
        /// Use the default icons provided by the SDK.
        case system

        /// Define custom icons for the activity indicator.
        /// - Parameters:
        ///   - loading14: The icon for the 14px loading indicator.
        case custom(loading14: UIImage)

        /// Use a custom icons provider.
        /// - Parameters:
        ///   - provider: Supplies the custom icons.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.ActivityIndicatorTheme.Icons {
    /// A protocol for supplying custom icons for activity indicator themes.
    public protocol Provider {
        /// The icon for the 14px loading indicator.
        var loading14: UIImage { get }
    }
}

// MARK: - Colors

extension Aiuta.Configuration.UserInterface.ActivityIndicatorTheme {
    /// Configures the colors for the activity indicator.
    public enum Colors {
        /// Use the default colors provided by the SDK.
        case `default`

        /// Define custom colors for the activity indicator.
        /// - Parameters:
        ///   - overlay: The overlay color.
        case custom(overlay: UIColor)

        /// Use a custom colors provider.
        /// - Parameters:
        ///   - provider: Supplies the custom colors.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.ActivityIndicatorTheme.Colors {
    /// A protocol for supplying custom colors for activity indicator themes.
    public protocol Provider {
        /// The overlay color.
        var overlay: UIColor { get }
    }
}

// MARK: - Settings

extension Aiuta.Configuration.UserInterface.ActivityIndicatorTheme {
    /// Configures the behavior and animation of the activity indicator.
    public enum Settings {
        /// Use the default settings provided by the SDK.
        case `default`

        /// Define custom settings for the activity indicator.
        /// - Parameters:
        ///   - indicationDelay: The delay before showing the indicator (in miliseconds).
        ///   - spinDuration: The duration of the spin animation (in miliseconds).
        case custom(indicationDelay: Int = 1000,
                    spinDuration: Int = 2000)
    }
}
