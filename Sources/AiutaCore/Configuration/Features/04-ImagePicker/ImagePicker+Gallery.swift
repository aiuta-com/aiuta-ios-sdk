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
    /// Represents the photo gallery feature within the image picker. This allows
    /// you to configure how the gallery behaves, whether it uses default settings
    /// or is customized with specific icons and strings.
    public enum Gallery {
        /// Uses the default configuration for the photo gallery.
        case `default`

        /// Allows you to define a custom configuration for the photo gallery.
        ///
        /// - Parameters:
        ///   - icons: Custom icons to be used in the gallery interface.
        ///   - strings: Custom text content for the gallery interface.
        case custom(icons: Icons,
                    strings: Strings)
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.ImagePicker.Gallery {
    /// Represents the icons used in the photo gallery feature of the image picker.
    /// You can use default icons, provide custom ones, or supply them dynamically
    /// through a provider.
    public enum Icons {
        /// Uses the default set of icons provided by the SDK.
        case builtIn

        /// Allows you to specify custom icons for the gallery interface.
        ///
        /// - Parameters:
        ///   - gallery24: The icon displayed for the gallery button in the
        ///     bottom sheet list.
        case custom(gallery24: UIImage)

        /// Allows you to use a custom provider to supply icons dynamically.
        ///
        /// - Parameters:
        ///   - Provider: A provider that supplies the custom icons.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.ImagePicker.Gallery.Icons {
    /// A protocol for supplying custom icons to the photo gallery feature. You
    /// can implement this protocol to provide a custom set of icons.
    public protocol Provider {
        /// The icon displayed for the gallery button in the bottom sheet list.
        var gallery24: UIImage { get }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.ImagePicker.Gallery {
    /// Represents the text content used in the photo gallery feature of the image
    /// picker. You can use default text, provide custom strings, or supply them
    /// dynamically through a provider.
    public enum Strings {
        /// Uses the default text content provided by the SDK.
        case `default`

        /// Allows you to specify custom text content for the gallery interface.
        ///
        /// - Parameters:
        ///   - galleryButtonSelectPhoto: The label for the button used to select
        ///     a photo from the gallery.
        case custom(galleryButtonSelectPhoto: String)

        /// Allows you to use a custom provider to supply text content dynamically.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom text content.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.ImagePicker.Gallery.Strings {
    /// A protocol for supplying custom text content to the photo gallery feature.
    /// You can implement this protocol to provide button labels and other text.
    public protocol Provider {
        /// The label for the button used to select a photo from the gallery.
        var galleryButtonSelectPhoto: String { get }
    }
}
