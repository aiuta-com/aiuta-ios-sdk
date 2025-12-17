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
    /// Represents the configuration for the image picker feature. This feature
    /// allows users to select images from the photo library, take new photos,
    /// use predefined models, reuse previously uploaded images, and more.
    public enum ImagePicker {
        /// Uses the default configuration for the image picker.
        case `default`

        /// Allows customization of the image picker configuration.
        ///
        /// - Parameters:
        ///   - camera: Configuration for the camera functionality.
        ///   - gallery: Configuration for the photo gallery.
        ///   - predefinedModel: Configuration for predefined models.
        ///   - uploadsHistory: Configuration for managing upload history.
        ///   - images: Custom images to be used in the image picker.
        ///   - strings: Custom text content for the image picker.
        case custom(camera: Camera = .default,
                    photoGallery: Gallery = .default,
                    predefinedModels: PredefinedModels = .default,
                    uploadsHistory: UploadsHistory = .default,
                    images: Images = .builtIn,
                    strings: Strings = .default)
    }
}

// MARK: - Images

extension Aiuta.Configuration.Features.ImagePicker {
    /// Defines the images used in the image picker. You can use built-in images,
    /// provide custom images, or supply images dynamically through a provider.
    public enum Images {
        /// Uses the default set of images provided by the SDK.
        case builtIn

        /// Allows you to specify custom images for the image picker.
        ///
        /// - Parameters:
        ///   - imagePickerExamples: A collection of the exactly 2 example images to display in the picker.
        case custom(imagePickerExamples: [UIImage])

        /// Allows you to use a custom provider to supply images.
        ///
        /// - Parameters:
        ///   - Provider: A provider that supplies the custom images.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.ImagePicker.Images {
    /// A protocol for supplying images to the image picker. Implement this
    /// protocol to provide a custom set of images.
    public protocol Provider {
        /// A collection of the exactly 2 example images to display in the image picker.
        var imagePickerExamples: [UIImage] { get }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.ImagePicker {
    /// Defines the text content used in the image picker. You can use default
    /// text, provide custom strings, or supply text dynamically through a provider.
    public enum Strings {
        /// Uses the default text content provided by the SDK.
        case `default`

        /// Allows you to specify custom text content for the image picker.
        ///
        /// - Parameters:
        ///   - imagePickerTitle: The title displayed at the top of the image picker.
        ///   - imagePickerDescription: A description displayed when the image picker is empty.
        ///   - imagePickerButtonUploadPhoto: The label for the button used to upload a photo.
        case custom(imagePickerTitle: String,
                    imagePickerDescription: String,
                    imagePickerButtonUploadPhoto: String)

        /// Allows you to use a custom provider to supply text content dynamically.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom text content.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.ImagePicker.Strings {
    /// A protocol for supplying custom text content to the image picker.
    /// Implement this protocol to provide titles, descriptions, and button labels.
    public protocol Provider {
        /// The title displayed at the top of the image picker.
        var imagePickerTitle: String { get }

        /// A description displayed when the image picker is empty.
        var imagePickerDescription: String { get }

        /// The label for the button used to upload a photo.
        var imagePickerButtonUploadPhoto: String { get }
    }
}
