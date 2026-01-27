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
    /// Input validation configuration for the TryOn feature.
    public struct InputValidation: Sendable {
        /// Text content for input validation messages.
        public let strings: Strings
        
        /// Creates an input validation configuration.
        ///
        /// - Parameters:
        ///   - strings: Text content for input validation messages.
        public init(strings: Strings) {
            self.strings = strings
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.TryOn.InputValidation {
    /// Text content for input validation messages.
    public struct Strings: Sendable {
        /// Message displayed when the input image is invalid.
        public let invalidInputImageDescription: String
        
        /// Label for the button allowing users to change the photo.
        public let invalidInputImageChangePhotoButton: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - invalidInputImageDescription: Message displayed when the input image is invalid.
        ///   - invalidInputImageChangePhotoButton: Label for the button allowing users to change the photo.
        public init(invalidInputImageDescription: String,
                    invalidInputImageChangePhotoButton: String) {
            self.invalidInputImageDescription = invalidInputImageDescription
            self.invalidInputImageChangePhotoButton = invalidInputImageChangePhotoButton
        }
    }
}
