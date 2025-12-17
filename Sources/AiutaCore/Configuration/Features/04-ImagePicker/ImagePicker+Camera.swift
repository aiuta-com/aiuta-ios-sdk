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
    /// Represents the camera feature within the image picker configuration.
    /// This allows you to define how the camera functionality behaves, whether
    /// it uses default settings, is disabled, or is customized.
    public enum Camera {
        /// Uses the default camera configuration.
        case `default`

        /// Indicates that the camera functionality is not available.
        case none

        /// Allows you to define a custom camera configuration.
        ///
        /// - Parameters:
        ///   - icons: Custom icons to be used for the camera interface.
        ///   - strings: Custom text content for the camera interface.
        case custom(icons: Icons = .builtIn,
                    strings: Strings = .default)
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.ImagePicker.Camera {
    /// Represents the icons used in the camera feature of the image picker.
    /// You can use default icons, provide custom ones, or supply them
    /// dynamically through a provider.
    public enum Icons {
        /// Uses the default set of icons provided by the SDK.
        case builtIn

        /// Allows you to specify custom icons for the camera interface.
        ///
        /// - Parameters:
        ///   - camera24: The icon displayed for the camera button in the
        ///     bottom sheet list.
        case custom(camera24: UIImage)

        /// Allows you to use a custom provider to supply icons dynamically.
        ///
        /// - Parameters:
        ///   - Provider: A provider that supplies the custom icons.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.ImagePicker.Camera.Icons {
    /// A protocol for supplying custom icons to the camera feature. Implement
    /// this protocol to provide a custom set of icons dynamically.
    public protocol Provider {
        /// The icon displayed for the camera button in the bottom sheet list.
        var camera24: UIImage { get }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.ImagePicker.Camera {
    /// Represents the text content used in the camera feature of the image
    /// picker. You can use default text, provide custom strings, or supply
    /// them dynamically through a provider.
    public enum Strings {
        /// Uses the default text content provided by the SDK.
        case `default`

        /// Allows you to specify custom text content for the camera interface.
        ///
        /// - Parameters:
        ///   - cameraButtonTakePhoto: The label for the button used to take a photo.
        ///   - cameraPermissionTitle: The title displayed in the alert when
        ///     camera permissions are denied.
        ///   - cameraPermissionDescription: The description displayed in the
        ///     alert when camera permissions are denied.
        ///   - cameraPermissionButtonOpenSettings: The label for the button
        ///     that opens the app settings to change camera permissions.
        case custom(cameraButtonTakePhoto: String,
                    cameraPermissionTitle: String,
                    cameraPermissionDescription: String,
                    cameraPermissionButtonOpenSettings: String)

        /// Allows you to use a custom provider to supply text content dynamically.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom text content.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.ImagePicker.Camera.Strings {
    /// A protocol for supplying custom text content to the camera feature.
    /// Implement this protocol to provide titles, descriptions, and button labels.
    public protocol Provider {
        /// The label for the button used to take a photo.
        var cameraButtonTakePhoto: String { get }

        /// The title displayed in the alert when camera permissions are denied.
        var cameraPermissionTitle: String { get }

        /// The description displayed in the alert when camera permissions are denied.
        var cameraPermissionDescription: String { get }

        /// The label for the button that opens the app settings to change
        /// camera permissions.
        var cameraPermissionButtonOpenSettings: String { get }
    }
}
