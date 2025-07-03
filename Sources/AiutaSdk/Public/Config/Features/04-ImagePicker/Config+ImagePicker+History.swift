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
    /// Represents the feature for storing the history of images that users
    /// have uploaded for virtual try-on. This allows you to manage and
    /// customize how the upload history is handled.
    public enum UploadsHistory {
        /// Use the default configuration for uploads history.
        case `default`

        /// Disable the uploads history feature entirely.
        case none

        /// Define a custom configuration for uploads history.
        ///
        /// - Parameters:
        ///   - strings: Custom text content for the uploads history interface.
        ///   - styles: Custom styles for the uploads history interface.
        ///   - history: A custom provider to manage the uploads history data.
        case custom(strings: Strings = .default,
                    styles: Styles = .default,
                    history: HistoryProvider = .userDefaults)
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.ImagePicker.UploadsHistory {
    /// Represents the text content used in the uploads history feature. You
    /// can use default text, provide custom strings, or supply them dynamically
    /// through a provider.
    public enum Strings {
        /// Use the default text content provided by the SDK.
        case `default`

        /// Define custom text content for the uploads history interface.
        ///
        /// - Parameters:
        ///   - uploadsHistoryButtonNewPhoto: Text for the button to upload a new photo.
        ///   - uploadsHistoryTitle: Title text for the uploads history screen.
        ///   - uploadsHistoryButtonChangePhoto: Text for the button to change the photo.
        case custom(uploadsHistoryButtonNewPhoto: String,
                    uploadsHistoryTitle: String,
                    uploadsHistoryButtonChangePhoto: String)

        /// Use a custom provider to supply text content dynamically.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom text content.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.ImagePicker.UploadsHistory.Strings {
    /// A protocol for supplying custom text content to the uploads history
    /// feature. Implement this protocol to provide button labels, titles, and
    /// other text dynamically.
    public protocol Provider {
        /// Text for the button to upload a new photo.
        var uploadsHistoryButtonNewPhoto: String { get }

        /// Title text for the uploads history screen.
        var uploadsHistoryTitle: String { get }

        /// Text for the button to change the photo.
        var uploadsHistoryButtonChangePhoto: String { get }
    }
}

// MARK: - Styles

extension Aiuta.Configuration.Features.ImagePicker.UploadsHistory {
    /// Represents the styles used in the uploads history feature. You can use
    /// default styles or define custom styles to adjust the appearance of the
    /// interface.
    public enum Styles {
        /// Use the default styles provided by the SDK.
        case `default`

        /// Define custom styles for the uploads history interface.
        ///
        /// - Parameters:
        ///   - changePhotoButtonStyle: Style for the "Change Photo" button.
        case custom(changePhotoButtonStyle: Aiuta.Configuration.UserInterface.ComponentStyle)
    }
}

// MARK: - Data

extension Aiuta.Configuration.Features.ImagePicker.UploadsHistory {
    /// Represents the data provider for the uploads history feature. You can
    /// use built-in storage options or define a custom provider to manage the
    /// history data.
    public enum HistoryProvider {
        /// Use built-in `userDefaults` to store the uploads history.
        case userDefaults

        /// Define a custom data provider for managing the uploads history.
        ///
        /// - Parameters:
        ///   - provider: A custom provider that handles the history data and
        ///     operations.
        case dataProvider(DataProvider)
    }
}

extension Aiuta.Configuration.Features.ImagePicker.UploadsHistory {
    /// A protocol for providing custom data management for the uploads history.
    /// Implement this protocol to control how the history is stored, updated,
    /// and accessed.
    public protocol DataProvider {
        /// Represents the history of images uploaded by the user for virtual try-on.
        /// The most recently used image should appear first in the array.
        @available(iOS 13.0.0, *)
        var uploaded: Aiuta.Observable<[Aiuta.Image.Input]> { get async }

        /// Adds new images to the uploads history. You should store these images
        /// in the history for future use.
        ///
        /// - Parameters:
        ///   - images: An array of images to add to the history.
        @available(iOS 13.0.0, *)
        func add(uploaded images: [Aiuta.Image.Input]) async throws

        /// Removes images from the uploads history.
        ///
        /// - Parameters:
        ///   - images: An array of images to remove from the history.
        @available(iOS 13.0.0, *)
        func delete(uploaded images: [Aiuta.Image.Input]) async throws

        /// Move a selected image to the top of the uploads history. It will be
        /// called when a user reuses an image for virtual try-on.
        ///
        /// - Parameters:
        ///   - image: The image selected by the user.
        @available(iOS 13.0.0, *)
        func select(uploaded image: Aiuta.Image.Input) async throws
    }
}
