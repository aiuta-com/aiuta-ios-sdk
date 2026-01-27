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
    /// Camera feature configuration for the image picker.
    ///
    /// To disable camera functionality, set this to `nil` in the `ImagePicker` configuration.
    public struct Camera: Sendable {
        /// Icons for the camera interface.
        public let icons: Icons
        
        /// Text content for the camera interface.
        public let strings: Strings
        
        /// Creates a custom camera configuration.
        ///
        /// - Parameters:
        ///   - icons: Icons for the camera interface.
        ///   - strings: Text content for the camera interface.
        public init(icons: Icons,
                    strings: Strings) {
            self.icons = icons
            self.strings = strings
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.ImagePicker.Camera {
    /// Icons for the camera interface.
    public struct Icons: Sendable {
        /// Icon displayed for the camera button in the bottom sheet list (24x24).
        public let camera24: UIImage
        
        /// Creates custom icons.
        ///
        /// - Parameters:
        ///   - camera24: Icon displayed for the camera button in the bottom sheet list (24x24).
        public init(camera24: UIImage) {
            self.camera24 = camera24
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.ImagePicker.Camera {
    /// Text content for the camera interface.
    public struct Strings: Sendable {
        /// Label for the button used to take a photo.
        public let cameraButtonTakePhoto: String
        
        /// Title displayed in the alert when camera permissions are denied.
        public let cameraPermissionTitle: String
        
        /// Description displayed in the alert when camera permissions are denied.
        public let cameraPermissionDescription: String
        
        /// Label for the button that opens the app settings to change camera permissions.
        public let cameraPermissionButtonOpenSettings: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - cameraButtonTakePhoto: Label for the button used to take a photo.
        ///   - cameraPermissionTitle: Title displayed in the alert when camera permissions are denied.
        ///   - cameraPermissionDescription: Description displayed in the alert when camera permissions are denied.
        ///   - cameraPermissionButtonOpenSettings: Label for the button that opens the app settings to change camera permissions.
        public init(cameraButtonTakePhoto: String,
                    cameraPermissionTitle: String,
                    cameraPermissionDescription: String,
                    cameraPermissionButtonOpenSettings: String) {
            self.cameraButtonTakePhoto = cameraButtonTakePhoto
            self.cameraPermissionTitle = cameraPermissionTitle
            self.cameraPermissionDescription = cameraPermissionDescription
            self.cameraPermissionButtonOpenSettings = cameraPermissionButtonOpenSettings
        }
    }
}
