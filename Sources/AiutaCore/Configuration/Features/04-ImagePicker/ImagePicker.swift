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
    /// Image picker feature configuration.
    ///
    /// Allows users to select images from the photo library, take new photos,
    /// use predefined models, reuse previously uploaded images, and more.
    public struct ImagePicker: Sendable {
        /// Camera functionality configuration. Set to `nil` to disable.
        public let camera: Camera?
        
        /// Photo gallery configuration.
        public let photoGallery: Gallery
        
        /// Predefined models configuration. Set to `nil` to disable.
        public let predefinedModels: PredefinedModels?
        
        /// Uploads history configuration. Set to `nil` to disable.
        public let uploadsHistory: UploadsHistory?
        
        /// Example images displayed in the picker.
        public let images: Images
        
        /// Text content for the image picker.
        public let strings: Strings
        
        /// Creates a custom image picker configuration.
        ///
        /// - Parameters:
        ///   - camera: Camera functionality configuration. Set to `nil` to disable.
        ///   - photoGallery: Photo gallery configuration.
        ///   - predefinedModels: Predefined models configuration. Set to `nil` to disable.
        ///   - uploadsHistory: Uploads history configuration. Set to `nil` to disable.
        ///   - images: Example images displayed in the picker.
        ///   - strings: Text content for the image picker.
        public init(camera: Camera?,
                    photoGallery: Gallery,
                    predefinedModels: PredefinedModels?,
                    uploadsHistory: UploadsHistory?,
                    images: Images,
                    strings: Strings) {
            self.camera = camera
            self.photoGallery = photoGallery
            self.predefinedModels = predefinedModels
            self.uploadsHistory = uploadsHistory
            self.images = images
            self.strings = strings
        }
    }
}

// MARK: - Images

extension Aiuta.Configuration.Features.ImagePicker {
    /// Example images displayed in the picker.
    public struct Images: Sendable {
        /// Collection of exactly 2 example images to display in the picker.
        public let imagePickerExamples: [UIImage]
        
        /// Creates custom images.
        ///
        /// - Parameters:
        ///   - imagePickerExamples: Collection of exactly 2 example images to display in the picker.
        public init(imagePickerExamples: [UIImage]) {
            self.imagePickerExamples = imagePickerExamples
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.ImagePicker {
    /// Text content for the image picker.
    public struct Strings: Sendable {
        /// Title displayed at the top of the image picker.
        public let imagePickerTitle: String
        
        /// Description displayed when the image picker is empty.
        public let imagePickerDescription: String
        
        /// Label for the button used to upload a photo.
        public let imagePickerButtonUploadPhoto: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - imagePickerTitle: Title displayed at the top of the image picker.
        ///   - imagePickerDescription: Description displayed when the image picker is empty.
        ///   - imagePickerButtonUploadPhoto: Label for the button used to upload a photo.
        public init(imagePickerTitle: String,
                    imagePickerDescription: String,
                    imagePickerButtonUploadPhoto: String) {
            self.imagePickerTitle = imagePickerTitle
            self.imagePickerDescription = imagePickerDescription
            self.imagePickerButtonUploadPhoto = imagePickerButtonUploadPhoto
        }
    }
}
