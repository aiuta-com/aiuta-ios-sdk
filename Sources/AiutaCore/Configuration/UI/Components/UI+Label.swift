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
    /// Label theme configuration.
    public struct LabelTheme: Sendable {
        /// Typography styles for different text elements.
        public let typography: Typography
        
        /// Creates a custom label theme.
        ///
        /// - Parameters:
        ///   - typography: Typography styles for different text elements.
        public init(typography: Typography) {
            self.typography = typography
        }
    }
}

extension Aiuta.Configuration.UserInterface.LabelTheme {
    /// Typography styles for label text elements.
    public struct Typography: Sendable {
        /// Text style for large titles.
        public let titleL: Aiuta.Configuration.TextStyle
        
        /// Text style for medium titles.
        public let titleM: Aiuta.Configuration.TextStyle
        
        /// Text style for regular body text.
        public let regular: Aiuta.Configuration.TextStyle
        
        /// Text style for subtle/secondary text.
        public let subtle: Aiuta.Configuration.TextStyle
        
        /// Creates custom typography styles.
        ///
        /// - Parameters:
        ///   - titleL: Text style for large titles.
        ///   - titleM: Text style for medium titles.
        ///   - regular: Text style for regular body text.
        ///   - subtle: Text style for subtle/secondary text.
        public init(titleL: Aiuta.Configuration.TextStyle,
                    titleM: Aiuta.Configuration.TextStyle,
                    regular: Aiuta.Configuration.TextStyle,
                    subtle: Aiuta.Configuration.TextStyle) {
            self.titleL = titleL
            self.titleM = titleM
            self.regular = regular
            self.subtle = subtle
        }
    }
}
