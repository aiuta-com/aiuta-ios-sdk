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
    /// Fit disclaimer configuration for the TryOn feature.
    public struct FitDisclaimer: Sendable {
        /// Text content for the fit disclaimer.
        public let strings: Strings
        
        /// Typography for the fit disclaimer.
        public let typography: Typography
        
        /// Icons for the fit disclaimer.
        public let icons: Icons
        
        /// Creates a fit disclaimer configuration.
        ///
        /// - Parameters:
        ///   - strings: Text content for the fit disclaimer.
        ///   - typography: Typography for the fit disclaimer.
        ///   - icons: Icons for the fit disclaimer.
        public init(strings: Strings,
                    typography: Typography,
                    icons: Icons) {
            self.strings = strings
            self.typography = typography
            self.icons = icons
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.TryOn.FitDisclaimer {
    /// Text content for the fit disclaimer.
    public struct Strings: Sendable {
        /// Title displayed in the fit disclaimer.
        public let fitDisclaimerTitle: String
        
        /// Description text in the fit disclaimer.
        public let fitDisclaimerDescription: String
        
        /// Label for the close button.
        public let fitDisclaimerCloseButton: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - fitDisclaimerTitle: Title displayed in the fit disclaimer.
        ///   - fitDisclaimerDescription: Description text in the fit disclaimer.
        ///   - fitDisclaimerCloseButton: Label for the close button.
        public init(fitDisclaimerTitle: String,
                    fitDisclaimerDescription: String,
                    fitDisclaimerCloseButton: String) {
            self.fitDisclaimerTitle = fitDisclaimerTitle
            self.fitDisclaimerDescription = fitDisclaimerDescription
            self.fitDisclaimerCloseButton = fitDisclaimerCloseButton
        }
    }
}

// MARK: - Typography

extension Aiuta.Configuration.Features.TryOn.FitDisclaimer {
    /// Typography for the fit disclaimer.
    public struct Typography: Sendable {
        /// Text style for the disclaimer text.
        public let disclaimer: Aiuta.Configuration.TextStyle
        
        /// Creates custom typography.
        ///
        /// - Parameters:
        ///   - disclaimer: Text style for the disclaimer text.
        public init(disclaimer: Aiuta.Configuration.TextStyle) {
            self.disclaimer = disclaimer
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.TryOn.FitDisclaimer {
    /// Icons for the fit disclaimer.
    public struct Icons: Sendable {
        /// Icon displayed in the fit disclaimer.
        public let info20: UIImage?
        
        /// Creates custom icons.
        ///
        /// - Parameters:
        ///   - info20: Icon displayed in the fit disclaimer.
        public init(info20: UIImage?) {
            self.info20 = info20
        }
    }
}
