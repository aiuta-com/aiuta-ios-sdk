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
    /// Optional share feature configuration.
    public struct Share: Sendable {
        /// Optional watermark configuration for shared content.
        public let watermark: Watermark
        
        /// Configuration for providing additional text to share.
        public let text: AdditionalTextProvider
        
        /// Icons for the share feature.
        public let icons: Icons
        
        /// Text content for the share feature.
        public let strings: Strings
        
        /// Creates a share feature configuration.
        ///
        /// - Parameters:
        ///   - watermark: Optional watermark configuration for shared content.
        ///   - text: Configuration for providing additional text to share.
        ///   - icons: Icons for the share feature.
        ///   - strings: Text content for the share feature.
        public init(watermark: Watermark,
                    text: AdditionalTextProvider,
                    icons: Icons,
                    strings: Strings) {
            self.watermark = watermark
            self.text = text
            self.icons = icons
            self.strings = strings
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.Share {
    /// Icons for the share feature.
    public struct Icons: Sendable {
        /// Icon displayed for the share button.
        public let share24: UIImage
        
        /// Creates custom icons.
        ///
        /// - Parameters:
        ///   - share24: Icon displayed for the share button.
        public init(share24: UIImage) {
            self.share24 = share24
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.Share {
    /// Text content for the share feature.
    public struct Strings: Sendable {
        /// Label for the share button in the fullscreen gallery.
        public let shareButton: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - shareButton: Label for the share button in the fullscreen gallery.
        public init(shareButton: String) {
            self.shareButton = shareButton
        }
    }
}

// MARK: - Data Provider

extension Aiuta.Configuration.Features.Share {
    /// Configuration for additional text to be shared along with the generated image.
    public enum AdditionalTextProvider {
        /// No additional text will be added to the shared content.
        case none

        /// Uses a custom provider to generate additional share text dynamically.
        case dataProvider(DataProvider)
    }
}

extension Aiuta.Configuration.Features.Share {
    /// Protocol for providing custom share text dynamically.
    public protocol DataProvider {
        /// Generates additional share text for the given product IDs.
        ///
        /// - Parameters:
        ///   - productIds: List of product IDs to generate the share text for.
        /// - Returns: Optional share text to be included with the shared content.
        @available(iOS 13.0.0, *)
        func getShareText(productIds: [String]) async throws -> String?
    }
}
