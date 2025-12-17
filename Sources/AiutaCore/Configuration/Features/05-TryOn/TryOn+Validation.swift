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

extension Aiuta.Configuration.Features.TryOn {
    /// Configures the input validation for the TryOn feature. You can use the
    /// default validation settings or provide custom strings to customize the
    /// validation messages displayed to users.
    public enum InputValidation {
        /// Use the default input validation settings.
        case `default`

        /// Use a custom configuration for input validation.
        ///
        /// - Parameters:
        ///   - strings: Custom text content for input validation messages.
        case custom(strings: Strings)
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.TryOn.InputValidation {
    /// Defines the text content used for input validation in the TryOn feature.
    /// You can use the default text, provide custom strings, or supply them
    /// through a provider.
    public enum Strings {
        /// Use the default text content for input validation.
        case `default`

        /// Specify custom text content for input validation.
        ///
        /// - Parameters:
        ///   - invalidInputImageDescription: The message displayed when the
        ///     input image is invalid.
        ///   - invalidInputImageChangePhotoButton: The label for the button
        ///     allowing users to change the photo.
        case custom(invalidInputImageDescription: String,
                    invalidInputImageChangePhotoButton: String)

        /// Use a custom provider to supply text content.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom text content.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.TryOn.InputValidation.Strings {
    /// A protocol for supplying custom text content for input validation.
    /// Implement this protocol to provide messages and button
    /// labels for invalid input scenarios.
    public protocol Provider {
        /// The message displayed when the input image is invalid.
        var invalidInputImageDescription: String { get }

        /// The label for the button allowing users to change the photo.
        var invalidInputImageChangePhotoButton: String { get }
    }
}
