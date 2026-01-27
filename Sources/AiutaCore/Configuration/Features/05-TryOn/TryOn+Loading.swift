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
    /// Loading page configuration for the TryOn feature.
    public struct LoadingPage: Sendable {
        /// Text content for the loading page.
        public let strings: Strings
        
        /// Visual styles for the loading page.
        public let styles: Styles
        
        /// Creates a custom loading page configuration.
        ///
        /// - Parameters:
        ///   - strings: Text content for the loading page.
        ///   - styles: Visual styles for the loading page.
        public init(strings: Strings,
                    styles: Styles) {
            self.strings = strings
            self.styles = styles
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.TryOn.LoadingPage {
    /// Text content for the loading page.
    public struct Strings: Sendable {
        /// Text displayed while uploading the image.
        public let tryOnLoadingStatusUploadingImage: String
        
        /// Text displayed while scanning the body.
        public let tryOnLoadingStatusScanningBody: String
        
        /// Text displayed while generating the outfit.
        public let tryOnLoadingStatusGeneratingOutfit: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - tryOnLoadingStatusUploadingImage: Text displayed while uploading the image.
        ///   - tryOnLoadingStatusScanningBody: Text displayed while scanning the body.
        ///   - tryOnLoadingStatusGeneratingOutfit: Text displayed while generating the outfit.
        public init(tryOnLoadingStatusUploadingImage: String,
                    tryOnLoadingStatusScanningBody: String,
                    tryOnLoadingStatusGeneratingOutfit: String) {
            self.tryOnLoadingStatusUploadingImage = tryOnLoadingStatusUploadingImage
            self.tryOnLoadingStatusScanningBody = tryOnLoadingStatusScanningBody
            self.tryOnLoadingStatusGeneratingOutfit = tryOnLoadingStatusGeneratingOutfit
        }
    }
}

// MARK: - Styles

extension Aiuta.Configuration.Features.TryOn.LoadingPage {
    /// Visual styles for the loading page.
    public struct Styles: Sendable {
        /// Gradient background for the loading page.
        public let backgroundGradient: [UIColor]
        
        /// Style for the status indicator.
        public let statusStyle: Aiuta.Configuration.UserInterface.ComponentStyle
        
        /// Creates custom styles.
        ///
        /// - Parameters:
        ///   - backgroundGradient: Gradient background for the loading page.
        ///   - statusStyle: Style for the status indicator.
        public init(backgroundGradient: [UIColor],
                    statusStyle: Aiuta.Configuration.UserInterface.ComponentStyle) {
            self.backgroundGradient = backgroundGradient
            self.statusStyle = statusStyle
        }
    }
}
