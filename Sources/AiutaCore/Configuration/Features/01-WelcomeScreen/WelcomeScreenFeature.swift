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
    /// screen will appear every time the SDK is opened.
    ///
    /// To disable this feature, set it to `nil` in the `Features` configuration.
    ///
    /// There are no built-in resources for the welcome screen. You need to
    /// provide your own images, icons, strings, and typography styles.
    public struct WelcomeScreen: Sendable {
        /// Images displayed on the welcome screen.
        public let images: Images
        
        /// Icons used on the welcome screen.
        public let icons: Icons
        
        /// Text content for the welcome screen.
        public let strings: Strings
        
        /// Text styles for the welcome screen.
        public let typography: Typography
        
        /// Creates a custom welcome screen configuration.
        ///
        /// - Parameters:
        ///   - images: Images displayed on the welcome screen.
        ///   - icons: Icons used on the welcome screen.
        ///   - strings: Text content for the welcome screen.
        ///   - typography: Text styles for the welcome screen.
        public init(images: Images,
                    icons: Icons,
                    strings: Strings,
                    typography: Typography) {
            self.images = images
            self.icons = icons
            self.strings = strings
            self.typography = typography
        }
    }
}

// MARK: - Images

extension Aiuta.Configuration.Features.WelcomeScreen {
    /// Images used on the welcome screen.
    public struct Images: Sendable {
        /// Background image that fills the entire screen.
        public let welcomeBackground: UIImage
        
        /// Creates custom images.
        ///
        /// - Parameters:
        ///   - welcomeBackground: Background image that fills the entire screen.
        public init(welcomeBackground: UIImage) {
            self.welcomeBackground = welcomeBackground
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.WelcomeScreen {
    /// Icons used on the welcome screen.
    public struct Icons: Sendable {
        /// Icon displayed near the center of the screen, above the title (82x82).
        public let welcome82: UIImage
        
        /// Creates custom icons.
        ///
        /// - Parameters:
        ///   - welcome82: Icon displayed near the center of the screen, above the title (82x82).
        public init(welcome82: UIImage) {
            self.welcome82 = welcome82
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.WelcomeScreen {
    /// Text content for the welcome screen.
    public struct Strings: Sendable {
        /// Title displayed on the welcome screen.
        public let welcomeTitle: String
        
        /// Description text displayed on the welcome screen.
        public let welcomeDescription: String
        
        /// Text for the button that starts the onboarding process or shows the main interface.
        public let welcomeButtonStart: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - welcomeTitle: Title displayed on the welcome screen.
        ///   - welcomeDescription: Description text displayed on the welcome screen.
        ///   - welcomeButtonStart: Text for the button that starts the onboarding process or shows the main interface.
        public init(welcomeTitle: String,
                    welcomeDescription: String,
                    welcomeButtonStart: String) {
            self.welcomeTitle = welcomeTitle
            self.welcomeDescription = welcomeDescription
            self.welcomeButtonStart = welcomeButtonStart
        }
    }
}

// MARK: - Typography

extension Aiuta.Configuration.Features.WelcomeScreen {
    /// Text styles for the welcome screen.
    public struct Typography: Sendable {
        /// Text style for the welcome screen title.
        public let welcomeTitle: Aiuta.Configuration.TextStyle
        
        /// Text style for the welcome screen description.
        public let welcomeDescription: Aiuta.Configuration.TextStyle
        
        /// Creates custom text styles.
        ///
        /// - Parameters:
        ///   - welcomeTitle: Text style for the welcome screen title.
        ///   - welcomeDescription: Text style for the welcome screen description.
        public init(welcomeTitle: Aiuta.Configuration.TextStyle,
                    welcomeDescription: Aiuta.Configuration.TextStyle) {
            self.welcomeTitle = welcomeTitle
            self.welcomeDescription = welcomeDescription
        }
    }
}
