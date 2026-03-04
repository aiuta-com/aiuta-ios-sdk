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

import AiutaCore
import UIKit

extension Aiuta.Configuration.Features.ImagePicker {
    /// Protection disclaimer configuration for the image picker.
    ///
    /// To disable the protection disclaimer, set this to `nil` in the `ImagePicker` configuration.
    public struct ProtectionDisclaimer: Sendable {
        /// Icons for the protection disclaimer.
        public let icons: Icons

        /// Text content for the protection disclaimer.
        public let strings: Strings

        /// Creates a custom protection disclaimer configuration.
        ///
        /// - Parameters:
        ///   - icons: Icons for the protection disclaimer.
        ///   - strings: Text content for the protection disclaimer.
        public init(icons: Icons,
                    strings: Strings) {
            self.icons = icons
            self.strings = strings
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.ImagePicker.ProtectionDisclaimer {
    /// Icons for the protection disclaimer.
    public struct Icons: Sendable {
        /// Icon displayed for the protection disclaimer (16x16).
        public let protection16: UIImage

        /// Creates custom icons.
        ///
        /// - Parameters:
        ///   - protection16: Icon displayed for the protection disclaimer (16x16).
        public init(protection16: UIImage) {
            self.protection16 = protection16
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.ImagePicker.ProtectionDisclaimer {
    /// Text content for the protection disclaimer.
    public struct Strings: Sendable {
        /// Text displayed in the protection disclaimer.
        public let protectionDisclaimer: String

        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - protectionDisclaimer: Text displayed in the protection disclaimer.
        public init(protectionDisclaimer: String) {
            self.protectionDisclaimer = protectionDisclaimer
        }
    }
}
