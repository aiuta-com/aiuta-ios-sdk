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
    /// Uploads history feature configuration for the image picker.
    ///
    /// Stores the history of images that users have uploaded for virtual try-on.
    /// To disable this feature, set it to `nil` in the `ImagePicker` configuration.
    public struct UploadsHistory: Sendable {
        /// Text content for the uploads history interface.
        public let strings: Strings
        
        /// Visual styles for the uploads history interface.
        public let styles: Styles
        
        /// Provider to manage the uploads history data.
        public let history: HistoryProvider
        
        /// Creates a custom uploads history configuration.
        ///
        /// - Parameters:
        ///   - strings: Text content for the uploads history interface.
        ///   - styles: Visual styles for the uploads history interface.
        ///   - history: Provider to manage the uploads history data.
        public init(strings: Strings,
                    styles: Styles,
                    history: HistoryProvider) {
            self.strings = strings
            self.styles = styles
            self.history = history
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.ImagePicker.UploadsHistory {
    /// Text content for the uploads history interface.
    public struct Strings: Sendable {
        /// Text for the button to upload a new photo.
        public let uploadsHistoryButtonNewPhoto: String
        
        /// Title text for the uploads history screen.
        public let uploadsHistoryTitle: String
        
        /// Text for the button to change the photo.
        public let uploadsHistoryButtonChangePhoto: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - uploadsHistoryButtonNewPhoto: Text for the button to upload a new photo.
        ///   - uploadsHistoryTitle: Title text for the uploads history screen.
        ///   - uploadsHistoryButtonChangePhoto: Text for the button to change the photo.
        public init(uploadsHistoryButtonNewPhoto: String,
                    uploadsHistoryTitle: String,
                    uploadsHistoryButtonChangePhoto: String) {
            self.uploadsHistoryButtonNewPhoto = uploadsHistoryButtonNewPhoto
            self.uploadsHistoryTitle = uploadsHistoryTitle
            self.uploadsHistoryButtonChangePhoto = uploadsHistoryButtonChangePhoto
        }
    }
}

// MARK: - Styles

extension Aiuta.Configuration.Features.ImagePicker.UploadsHistory {
    /// Visual styles for the uploads history interface.
    public struct Styles: Sendable {
        /// Style for the "Change Photo" button.
        public let changePhotoButtonStyle: Aiuta.Configuration.UserInterface.ComponentStyle
        
        /// Creates custom styles.
        ///
        /// - Parameters:
        ///   - changePhotoButtonStyle: Style for the "Change Photo" button.
        public init(changePhotoButtonStyle: Aiuta.Configuration.UserInterface.ComponentStyle) {
            self.changePhotoButtonStyle = changePhotoButtonStyle
        }
    }
}

// MARK: - Data

extension Aiuta.Configuration.Features.ImagePicker.UploadsHistory {
    /// Data provider for the uploads history feature.
    ///
    /// Manages how history data is stored and retrieved.
    public enum HistoryProvider {
        /// Use built-in `userDefaults` to store the uploads history.
        case userDefaults
        
        /// Use a custom data provider for managing the uploads history.
        ///
        /// - Parameters:
        ///   - provider: Custom provider that handles the history data and operations.
        case dataProvider(DataProvider)
    }
}

extension Aiuta.Configuration.Features.ImagePicker.UploadsHistory {
    /// A protocol for providing custom data management for the uploads history.
    ///
    /// Implement this protocol to control how the history is stored, updated,
    /// and accessed.
    public protocol DataProvider {
        /// History of images uploaded by the user for virtual try-on.
        /// The most recently used image should appear first in the array.
        @available(iOS 13.0.0, *)
        var uploaded: Aiuta.Observable<[Aiuta.InputImage]> { get async }
        
        /// Adds new images to the uploads history. You should store these images
        /// in the history for future use.
        ///
        /// - Parameters:
        ///   - images: Array of images to add to the history.
        @available(iOS 13.0.0, *)
        func add(uploaded images: [Aiuta.InputImage]) async throws
        
        /// Removes images from the uploads history.
        ///
        /// - Parameters:
        ///   - images: Array of images to remove from the history.
        @available(iOS 13.0.0, *)
        func delete(uploaded images: [Aiuta.InputImage]) async throws
        
        /// Move a selected image to the top of the uploads history. It will be
        /// called when a user reuses an image for virtual try-on.
        ///
        /// - Parameters:
        ///   - image: Image selected by the user.
        @available(iOS 13.0.0, *)
        func select(uploaded image: Aiuta.InputImage) async throws
    }
}
