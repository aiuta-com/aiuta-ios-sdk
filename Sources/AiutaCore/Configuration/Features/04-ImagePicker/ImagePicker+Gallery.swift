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

extension Aiuta.Configuration.Features.ImagePicker {
    /// Photo gallery feature configuration for the image picker.
    public struct Gallery: Sendable {
        /// Icons for the gallery interface.
        public let icons: Icons
        
        /// Text content for the gallery interface.
        public let strings: Strings
        
        /// Creates a custom gallery configuration.
        ///
        /// - Parameters:
        ///   - icons: Icons for the gallery interface.
        ///   - strings: Text content for the gallery interface.
        public init(icons: Icons,
                    strings: Strings) {
            self.icons = icons
            self.strings = strings
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.ImagePicker.Gallery {
    /// Icons for the gallery interface.
    public struct Icons: Sendable {
        /// Icon displayed for the gallery button in the bottom sheet list (24x24).
        public let gallery24: UIImage
        
        /// Creates custom icons.
        ///
        /// - Parameters:
        ///   - gallery24: Icon displayed for the gallery button in the bottom sheet list (24x24).
        public init(gallery24: UIImage) {
            self.gallery24 = gallery24
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.ImagePicker.Gallery {
    /// Text content for the gallery interface.
    public struct Strings: Sendable {
        /// Label for the button used to select a photo from the gallery.
        public let galleryButtonSelectPhoto: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - galleryButtonSelectPhoto: Label for the button used to select a photo from the gallery.
        public init(galleryButtonSelectPhoto: String) {
            self.galleryButtonSelectPhoto = galleryButtonSelectPhoto
        }
    }
}
