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
    /// Button theme configuration.
    public struct ButtonTheme: Sendable {
        /// Text styles for button labels.
        public let typography: Typography
        
        /// Corner radius and shape styles for button containers.
        public let shapes: Shapes
        
        /// Creates a custom button theme.
        ///
        /// - Parameters:
        ///   - typography: Text styles for button labels.
        ///   - shapes: Corner radius and shape styles for button containers.
        public init(typography: Typography,
                    shapes: Shapes) {
            self.typography = typography
            self.shapes = shapes
        }
    }
}

// MARK: - Shapes

extension Aiuta.Configuration.UserInterface.ButtonTheme {
    /// Shape styles for button containers.
    public struct Shapes: Sendable {
        /// Shape style for medium-sized buttons.
        public let buttonM: Aiuta.Configuration.Shape
        
        /// Shape style for small buttons.
        public let buttonS: Aiuta.Configuration.Shape
        
        /// Creates custom button shapes.
        ///
        /// - Parameters:
        ///   - buttonM: Shape style for medium-sized buttons.
        ///   - buttonS: Shape style for small buttons.
        public init(buttonM: Aiuta.Configuration.Shape,
                    buttonS: Aiuta.Configuration.Shape) {
            self.buttonM = buttonM
            self.buttonS = buttonS
        }
    }
}

// MARK: - Typography

extension Aiuta.Configuration.UserInterface.ButtonTheme {
    /// Text styles for button labels.
    public struct Typography: Sendable {
        /// Text style for medium-sized button labels.
        public let buttonM: Aiuta.Configuration.TextStyle
        
        /// Text style for small button labels.
        public let buttonS: Aiuta.Configuration.TextStyle
        
        /// Creates custom typography for button text.
        ///
        /// - Parameters:
        ///   - buttonM: The text style to apply to medium buttons.
        ///   - buttonS: The text style to apply to small buttons.
        public init(buttonM: Aiuta.Configuration.TextStyle,
                    buttonS: Aiuta.Configuration.TextStyle) {
            self.buttonM = buttonM
            self.buttonS = buttonS
        }
    }
}
