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
    /// Configures the loading page for the TryOn feature. You can use the default
    /// settings or customize the appearance and behavior by providing specific
    /// strings and styles.
    public enum LoadingPage {
        /// Use the default configuration for the loading page.
        case `default`

        /// Use a custom configuration for the loading page.
        ///
        /// - Parameters:
        ///   - strings: Custom text content for the loading page.
        ///   - styles: Custom styles for the loading page.
        case custom(strings: Strings,
                    styles: Styles)
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.TryOn.LoadingPage {
    /// Defines the text content used on the loading page. You can use the default
    /// text, provide custom strings, or supply them through a provider.
    public enum Strings {
        /// Use the default text content for the loading page.
        case `default`

        /// Specify custom text content for the loading page.
        ///
        /// - Parameters:
        ///   - tryOnLoadingStatusUploadingImage: Text displayed while uploading
        ///     the image.
        ///   - tryOnLoadingStatusScanningBody: Text displayed while scanning
        ///     the body.
        ///   - tryOnLoadingStatusGeneratingOutfit: Text displayed while generating
        ///     the outfit.
        case custom(tryOnLoadingStatusUploadingImage: String,
                    tryOnLoadingStatusScanningBody: String,
                    tryOnLoadingStatusGeneratingOutfit: String)

        /// Use a custom provider to supply text content.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom text content.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.TryOn.LoadingPage.Strings {
    /// A protocol for supplying custom text content for the loading page.
    /// Implement this protocol to provide text for various loading states.
    public protocol Provider {
        /// Text displayed while uploading the image.
        var tryOnLoadingStatusUploadingImage: String { get }

        /// Text displayed while scanning the body.
        var tryOnLoadingStatusScanningBody: String { get }

        /// Text displayed while generating the outfit.
        var tryOnLoadingStatusGeneratingOutfit: String { get }
    }
}

// MARK: - Styles

extension Aiuta.Configuration.Features.TryOn.LoadingPage {
    /// Defines the styles used on the loading page. You can use the default
    /// styles or provide custom ones to adjust the appearance of the interface.
    public enum Styles {
        /// Use the default styles for the loading page.
        case `default`

        /// Specify custom styles for the loading page.
        ///
        /// - Parameters:
        ///   - backgroundGradient: The gradient background for the loading page.
        ///   - statusStyle: The style for the status indicator.
        case custom(backgroundGradient: [UIColor],
                    statusStyle: Aiuta.Configuration.UserInterface.ComponentStyle)
    }
}
