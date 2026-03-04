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

import AiutaCore
import UIKit

extension Aiuta.Configuration.UserInterface {
    /// Image theme configuration.
    public struct ImageTheme: Sendable {
        /// Corner radius and shape styles for image containers.
        public let shapes: Shapes
        
        /// Error icon displayed when an image fails to load.
        public let icons: Icons
        
        /// Creates a custom image theme.
        ///
        /// - Parameters:
        ///   - shapes: Corner radius and shape styles for image containers.
        ///   - icons: Error icon displayed when an image fails to load.
        public init(shapes: Shapes,
                    icons: Icons) {
            self.shapes = shapes
            self.icons = icons
        }
    }
}

// MARK: - Shapes

extension Aiuta.Configuration.UserInterface.ImageTheme {
    /// Shape styles for image containers.
    public struct Shapes: Sendable {
        /// Shape style for large image views.
        public let imageL: Aiuta.Shape

        /// Shape style for medium image views.
        public let imageM: Aiuta.Shape

        /// Shape style for small image views.
        public let imageS: Aiuta.Shape

        /// Creates custom image shapes.
        ///
        /// - Parameters:
        ///   - imageL: Shape style for large image views.
        ///   - imageM: Shape style for medium image views.
        ///   - imageS: Shape style for small image views.
        public init(imageL: Aiuta.Shape,
                    imageM: Aiuta.Shape,
                    imageS: Aiuta.Shape) {
            self.imageL = imageL
            self.imageM = imageM
            self.imageS = imageS
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.UserInterface.ImageTheme {
    /// Error icon for failed image loads.
    public struct Icons: Sendable {
        /// Icon (36x36) displayed when an image cannot be loaded.
        public let imageError36: UIImage
        
        /// Creates custom icons for image placeholders.
        ///
        /// - Parameters:
        ///   - imageError36: The icon to display when an image cannot be loaded.
        public init(imageError36: UIImage) {
            self.imageError36 = imageError36
        }
    }
}
