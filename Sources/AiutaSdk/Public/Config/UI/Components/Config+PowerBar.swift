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
    /// Configures the appearance of the "Powered By Aiuta" label.
    ///
    /// This setting determines how the Power Bar looks and behaves. You can use
    /// the default theme or define a custom one to better align with your app's
    /// design and branding.
    public enum PowerBarTheme {
        /// Use the default Power Bar theme provided by the SDK.
        case `default`

        /// Define a custom Power Bar theme.
        ///
        /// - Parameters:
        ///   - strings: Configures the text strings used in the Power Bar.
        ///   - colors: Configures the color scheme for the Power Bar.
        case custom(strings: Strings = .default,
                    colors: Colors = .aiutaLight)
    }
}

// MARK: - Strings

extension Aiuta.Configuration.UserInterface.PowerBarTheme {
    /// Configures the text strings used in the Power Bar.
    ///
    /// Strings define the text displayed in the "Powered By Aiuta" label. You can
    /// use the default strings or define custom ones to better match your app's
    /// language and tone.
    public enum Strings {
        /// Use the default strings provided by the SDK.
        case `default`

        /// Define custom strings for the Power Bar.
        ///
        /// - Parameters:
        ///  - poweredByAiuta: The text for the "Powered By Aiuta" label.
        case custom(poweredByAiuta: String)

        /// Use a custom strings provider.
        ///
        /// - Parameters:
        ///  - provider: Supplies the custom strings.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.PowerBarTheme.Strings {
    /// Supplies custom strings for the Power Bar theme.
    ///
    /// This protocol defines the required text for the "Powered By Aiuta" label.
    /// - Note: Use the `Aiuta.Configuration.Strings` typealias for convenience.
    public protocol Provider {
        /// The text for the "Powered By Aiuta" label.
        var poweredByAiuta: String { get }
    }
}

// MARK: - Colors

extension Aiuta.Configuration.UserInterface.PowerBarTheme {
    /// Configures the color scheme for the Power Bar.
    ///
    /// Colors define the visual style of the "Powered By Aiuta" label, such as its
    /// text color. You can use the default color scheme or define custom colors to
    /// match your app's design language.
    public enum Colors {
        /// Defines the color schemes available for the Power Bar theme.
        public enum Scheme {
            /// Use the default color for the "Powered By Aiuta" label.
            case `default`

            /// Use a primary color for the "Powered By Aiuta" label.
            case primary
        }

        /// Use the default color scheme provided by the SDK.
        case aiutaLight

        /// Define custom colors for the Power Bar.
        ///
        /// - Parameters:
        ///   - aiuta: The color for the "Powered By Aiuta" label.
        case custom(aiuta: Scheme)

        /// Use a custom colors provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom colors.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.UserInterface.PowerBarTheme.Colors {
    /// Supplies custom colors for the Power Bar theme.
    ///
    /// This protocol defines the required colors, such as the text color for the
    /// "Powered By Aiuta" label.
    /// - Note: Use the `Aiuta.Configuration.Colors` typealias for convenience.
    public protocol Provider {
        /// The text color for the "Powered By Aiuta" label.
        var aiuta: Scheme { get }
    }
}
