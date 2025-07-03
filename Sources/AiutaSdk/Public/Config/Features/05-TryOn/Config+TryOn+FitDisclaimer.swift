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

extension Aiuta.Configuration.Features.TryOn {
    /// Configures the fit disclaimer for the TryOn feature. This allows you to
    /// use default settings or customize the text and icons displayed in the
    /// fit disclaimer.
    public enum FitDisclaimer {
        /// Use the default configuration for the fit disclaimer.
        case `default`

        /// Disable the fit disclaimer.
        case none

        /// Use a custom configuration for the fit disclaimer.
        ///
        /// - Parameters:
        ///   - strings: Custom text content for the fit disclaimer.
        ///   - typography: Custom typography for the fit disclaimer.
        ///   - icons: Custom icons for the fit disclaimer.
        case custom(strings: Strings,
                    typography: Typography,
                    icons: Icons)
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.TryOn.FitDisclaimer {
    /// Defines the text content used in the fit disclaimer. You can use the
    /// default text, provide custom strings, or implement a provider to manage
    /// the text content.
    public enum Strings {
        /// Use the default text content for the fit disclaimer.
        case `default`

        /// Specify custom text content for the fit disclaimer.
        ///
        /// - Parameters:
        ///   - fitDisclaimerTitle: The title displayed in the fit disclaimer.
        ///   - fitDisclaimerDescription: The description text in the fit disclaimer.
        ///   - fitDisclaimerCloseButton: The label for the close button.
        case custom(fitDisclaimerTitle: String,
                    fitDisclaimerDescription: String,
                    fitDisclaimerCloseButton: String)

        /// Use a provider to manage the text content for the fit disclaimer.
        ///
        /// - Parameters:
        ///   - provider: An object that implements the `Provider` protocol.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.TryOn.FitDisclaimer.Strings {
    /// A protocol for managing the text content of the fit disclaimer. Implement
    /// this protocol to define the title, description, and close button text.
    public protocol Provider {
        /// The title displayed in the fit disclaimer.
        var fitDisclaimerTitle: String { get }

        /// The description text in the fit disclaimer.
        var fitDisclaimerDescription: String { get }

        /// The label for the close button in the fit disclaimer.
        var fitDisclaimerCloseButton: String { get }
    }
}

// MARK: - Typography

extension Aiuta.Configuration.Features.TryOn.FitDisclaimer {
    public enum Typography {
        case `default`

        case custom(disclaimer: Aiuta.Configuration.TextStyle)

        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.TryOn.FitDisclaimer.Typography {
    public protocol Provider {
        var disclaimer: Aiuta.Configuration.TextStyle { get }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.TryOn.FitDisclaimer {
    /// Defines the icons used in the fit disclaimer. You can use no icons, provide
    /// custom ones, or implement a provider to manage the icons.
    public enum Icons {
        /// Do not display any icons in the fit disclaimer.
        case none

        /// Specify custom icons for the fit disclaimer.
        ///
        /// - Parameters:
        ///   - info20: The icon displayed in the fit disclaimer.
        case custom(info20: UIImage)

        /// Use a provider to manage the icons for the fit disclaimer.
        ///
        /// - Parameters:
        ///   - provider: An object that implements the `Provider` protocol.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.TryOn.FitDisclaimer.Icons {
    /// A protocol for managing the icons used in the fit disclaimer. Implement
    /// this protocol to define the icons displayed in the fit disclaimer.
    public protocol Provider {
        /// The icon displayed in the fit disclaimer.
        var info20: UIImage? { get }
    }
}
