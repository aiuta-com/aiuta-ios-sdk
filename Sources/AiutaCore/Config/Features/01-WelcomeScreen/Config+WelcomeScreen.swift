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

extension Aiuta.Configuration.Features {
    /// Configures the optional welcome or splash screen.
    ///
    /// This feature allows you to display a welcome screen when the SDK is opened
    /// for the first time. The welcome screen is shown only if the user has not
    /// completed the onboarding process. If onboarding is not provided, the welcome
    /// screen will appear every time the SDK is opened. You can control its visibility
    /// by including or excluding this feature in your configuration.
    ///
    /// There are no any built-in resources for the welcome screen. You need to
    /// provide your own images, icons, strings, and typography styles.
    public enum WelcomeScreen {
        /// Disables the welcome screen feature.
        case none

        /// Enables the welcome screen feature with custom settings.
        ///
        /// - Parameters:
        ///   - images: Configures the images displayed on the welcome screen.
        ///   - icons: Configures the icons used on the welcome screen.
        ///   - strings: Configures the text content for the welcome screen.
        ///   - typography: Configures the text styles for the welcome screen.
        case custom(images: Images,
                    icons: Icons,
                    strings: Strings,
                    typography: Typography)
    }
}

// MARK: - Images

extension Aiuta.Configuration.Features.WelcomeScreen {
    /// Configures the images used on the welcome screen.
    public enum Images {
        /// Uses custom images for the welcome screen.
        ///
        /// - Parameters:
        ///   - welcomeBackground: The background image that fills the entire screen.
        case custom(welcomeBackground: UIImage)

        /// Uses a custom image provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom images for the welcome screen.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.WelcomeScreen.Images {
    /// Supplies custom images for the welcome screen.
    ///
    /// - Note: Use the `Aiuta.Configuration.Images` typealias for convenience.
    public protocol Provider {
        /// The background image that fills the entire screen.
        var welcomeBackground: UIImage { get }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.WelcomeScreen {
    /// Configures the icons used on the welcome screen.
    public enum Icons {
        /// Uses custom icons for the welcome screen.
        ///
        /// - Parameters:
        ///   - welcome82: The icon displayed near the center of the screen, above
        ///     the title.
        case custom(welcome82: UIImage)

        /// Uses a custom icon provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom icons for the welcome screen.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.WelcomeScreen.Icons {
    /// Supplies custom icons for the welcome screen.
    ///
    /// - Note: Use the `Aiuta.Configuration.Icons` typealias for convenience.
    public protocol Provider {
        /// The icon displayed near the center of the welcome screen, above the title.
        var welcome82: UIImage { get }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.WelcomeScreen {
    /// Configures the text content for the welcome screen.
    public enum Strings {
        /// Uses custom text for the welcome screen.
        ///
        /// - Parameters:
        ///   - welcomeTitle: The title displayed on the welcome screen.
        ///   - welcomeDescription: The description text displayed on the welcome screen.
        ///   - welcomeButtonStart: The text for the button that starts the onboarding
        ///     process or shows the main interface.
        case custom(welcomeTitle: String,
                    welcomeDescription: String,
                    welcomeButtonStart: String)

        /// Uses a custom string provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom text for the welcome screen.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.WelcomeScreen.Strings {
    /// Supplies custom text for the welcome screen.
    ///
    /// - Note: Use the `Aiuta.Configuration.Strings` typealias for convenience.
    public protocol Provider {
        /// The title displayed on the welcome screen.
        var welcomeTitle: String { get }

        /// The description text displayed on the welcome screen.
        var welcomeDescription: String { get }

        /// The text for the button that starts the onboarding process or shows
        /// the main interface.
        var welcomeButtonStart: String { get }
    }
}

// MARK: - Typography

extension Aiuta.Configuration.Features.WelcomeScreen {
    /// Configures the text styles for the welcome screen.
    public enum Typography {
        case `default`
        
        /// Uses custom text styles for the welcome screen.
        ///
        /// - Parameters:
        ///   - welcomeTitle: The text style for the welcome screen title.
        ///   - welcomeDescription: The text style for the welcome screen description.
        case custom(welcomeTitle: Aiuta.Configuration.TextStyle,
                    welcomeDescription: Aiuta.Configuration.TextStyle)

        /// Uses a custom typography provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom text styles for the welcome screen.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.WelcomeScreen.Typography {
    /// Supplies custom text styles for the welcome screen.
    ///
    /// - Note: Use the `Aiuta.Configuration.Typography` typealias for convenience.
    public protocol Provider {
        /// The text style for the welcome screen title.
        var welcomeTitle: Aiuta.Configuration.TextStyle { get }

        /// The text style for the welcome screen description.
        var welcomeDescription: Aiuta.Configuration.TextStyle { get }
    }
}
