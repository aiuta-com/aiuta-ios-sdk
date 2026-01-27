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
    /// "Powered By Aiuta" label theme configuration.
    public struct PowerBarTheme: Sendable {
        /// Text strings used in the Power Bar.
        public let strings: Strings
        
        /// Color scheme for the Power Bar.
        public let colors: Colors
        
        /// Creates a custom Power Bar theme.
        ///
        /// - Parameters:
        ///   - strings: Text strings used in the Power Bar.
        ///   - colors: Color scheme for the Power Bar.
        public init(strings: Strings,
                    colors: Colors) {
            self.strings = strings
            self.colors = colors
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.UserInterface.PowerBarTheme {
    /// Text strings configuration for the Power Bar.
    public struct Strings: Sendable {
        /// The text for the "Powered By Aiuta" label.
        public let poweredByAiuta: String
        
        /// Creates custom strings configuration.
        ///
        /// - Parameters:
        ///  - poweredByAiuta: The text for the "Powered By Aiuta" label.
        public init(poweredByAiuta: String) {
            self.poweredByAiuta = poweredByAiuta
        }
    }
}

// MARK: - Colors

extension Aiuta.Configuration.UserInterface.PowerBarTheme {
    /// Color scheme options for the Power Bar.
    public enum ColorScheme: Sendable {
        /// Use the default color for the "Powered By Aiuta" label.
        case `default`

        /// Use a primary color for the "Powered By Aiuta" label.
        case primary
    }

    /// Color configuration for the Power Bar.
    public struct Colors: Sendable {
        /// The text color for the "Powered By Aiuta" label.
        public let aiuta: ColorScheme
        
        /// Creates custom color configuration.
        ///
        /// - Parameters:
        ///   - aiuta: The text color for the "Powered By Aiuta" label.
        public init(aiuta: ColorScheme) {
            self.aiuta = aiuta
        }
    }
}
