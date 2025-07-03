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
    /// Configures the optional share feature. This feature allows you to enable
    /// or disable sharing functionality and customize its behavior, including
    /// icons, strings, and additional text.
    public enum Share {
        /// Enables the share feature with default settings.
        case `default`
        
        /// Disables the share feature entirely.
        case none

        /// Enables the share feature with custom settings.
        ///
        /// - Parameters:
        ///   - watermark: Optional configuration for adding a watermark to shared content.
        ///   - text: Configuration for providing additional text to share.
        ///   - icons: Custom icons for the share feature.
        ///   - strings: Custom text content for the share feature.
        ///   - dataProvider: Optional provider for generating share text dynamically.
        case custom(watermark: Watermark = .none,
                    text: AdditionalTextProvider,
                    icons: Icons = .builtIn,
                    strings: Strings = .default)
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.Share {
    /// Defines the icons used in the share feature. You can use default icons,
    /// provide custom ones, or supply them dynamically through a provider.
    public enum Icons {
        /// Uses the default set of icons provided by the SDK.
        case builtIn

        /// Allows you to specify custom icons for the share feature.
        ///
        /// - Parameters:
        ///   - share24: The icon displayed for the share button.
        case custom(share24: UIImage)

        /// Allows you to use a custom provider to supply icons dynamically.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom icons.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.Share.Icons {
    /// A protocol for supplying custom icons to the share feature. Implement
    /// this protocol to provide a custom set of icons dynamically.
    public protocol Provider {
        /// The icon displayed for the share button.
        var share24: UIImage { get }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.Share {
    /// Defines the text content used in the share feature. You can use default
    /// text, provide custom strings, or supply them dynamically through a provider.
    public enum Strings {
        /// Uses the default text content provided by the SDK.
        case `default`

        /// Allows you to specify custom text content for the share feature.
        ///
        /// - Parameters:
        ///   - shareButton: The label for the share button in the fullscreen gallery.
        case custom(shareButton: String)

        /// Allows you to use a custom provider to supply text content dynamically.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom text content.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.Share.Strings {
    /// A protocol for supplying custom text content to the share feature.
    /// Implement this protocol to provide button label.
    public protocol Provider {
        /// The label for the share button in the fullscreen gallery.
        var shareButton: String { get }
    }
}

// MARK: - Data Provider

extension Aiuta.Configuration.Features.Share {
    /// Configures the additional text to be shared along with the generated image.
    /// You can choose to provide no text, use a default provider, or define
    /// a custom provider for dynamic text generation.
    public enum AdditionalTextProvider {
        /// No additional text will be added to the shared content.
        case none

        /// Uses a custom provider to generate additional share text dynamically.
        case dataProvider(DataProvider)
    }
}

extension Aiuta.Configuration.Features.Share.AdditionalTextProvider {
    /// A protocol for providing custom share text dynamically. Implement this
    /// protocol to generate text based on specific product IDs or other criteria.
    public protocol DataProvider {
        /// Generates additional share text for the given product IDs. This text
        /// will be included along with the shared image.
        ///
        /// - Parameters:
        ///   - productIds: A list of product IDs to generate the share text for.
        /// - Returns: Optional share text to be included with the shared content.
        @available(iOS 13.0.0, *)
        func getShareText(productIds: [String]) async throws -> String?
    }
}
