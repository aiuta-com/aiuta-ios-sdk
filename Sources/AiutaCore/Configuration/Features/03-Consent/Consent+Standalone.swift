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

extension Aiuta.Configuration.Features.Consent {
    /// Configuration for standalone consent page.
    public struct Standalone: Sendable {
        /// Text content for the standalone consent screen.
        public let strings: Strings
        
        /// Icons used in the standalone consent page.
        public let icons: Icons
        
        /// Visual styles for the standalone consent screen.
        public let styles: Styles
        
        /// Data provider for managing consent options.
        public let data: ConsentProvider
        
        /// Creates a standalone consent configuration.
        ///
        /// - Parameters:
        ///   - strings: Text content for the standalone consent screen.
        ///   - icons: Icons used in the standalone consent page.
        ///   - styles: Visual styles for the standalone consent screen.
        ///   - data: Data provider for managing consent options.
        public init(strings: Strings,
                    icons: Icons,
                    styles: Styles,
                    data: ConsentProvider) {
            self.strings = strings
            self.icons = icons
            self.styles = styles
            self.data = data
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.Consent.Standalone {
    /// Text content for the standalone consent screen.
    public struct Strings: Sendable {
        /// Optional title for the standalone consent page.
        public let consentPageTitle: String?
        
        /// Main title displayed on the consent page.
        public let consentTitle: String
        
        /// HTML content describing the consent.
        public let consentDescriptionHtml: String
        
        /// Optional HTML footer for the consent page.
        public let consentFooterHtml: String?
        
        /// Text for the "Accept" button.
        public let consentButtonAccept: String
        
        /// Optional text for the "Reject" button. If `nil`, the button will not
        /// be shown or used in `standaloneOnboardingPage` mode.
        /// If `nil`, the button will not be shown or used in `standaloneOnboardingPage` mode.
        public let consentButtonReject: String?
        
        /// Creates custom text content for the standalone consent page.
        ///
        /// - Parameters:
        ///   - consentPageTitle: Optional title for the standalone consent page.
        ///   - consentTitle: Main title displayed on the consent page.
        ///   - consentDescriptionHtml: HTML content describing the consent.
        ///   - consentFooterHtml: Optional HTML footer for the consent page.
        ///   - consentButtonAccept: Text for the "Accept" button.
        ///   - consentButtonReject: Optional text for the "Reject" button. 
        ///         If `nil`, the button will not be shown 
        ///         and used in `standaloneOnboardingPage` mode.
        public init(consentPageTitle: String?,
                    consentTitle: String,
                    consentDescriptionHtml: String,
                    consentFooterHtml: String?,
                    consentButtonAccept: String,
                    consentButtonReject: String?) {
            self.consentPageTitle = consentPageTitle
            self.consentTitle = consentTitle
            self.consentDescriptionHtml = consentDescriptionHtml
            self.consentFooterHtml = consentFooterHtml
            self.consentButtonAccept = consentButtonAccept
            self.consentButtonReject = consentButtonReject
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.Consent.Standalone {
    /// Icons used in the standalone consent page.
    public struct Icons: Sendable {
        /// Optional icon displayed next to the consent title (24x24).
        public let consentTitle24: UIImage?
        
        /// Creates custom icons for the standalone consent page.
        ///
        /// - Parameters:
        ///   - consentTitle24: Optional icon displayed next to the consent title (24x24).
        public init(consentTitle24: UIImage?) {
            self.consentTitle24 = consentTitle24
        }
    }
}

// MARK: - Styles

extension Aiuta.Configuration.Features.Consent.Standalone {
    /// Visual styles for the standalone consent screen.
    public struct Styles: Sendable {
        /// Whether to draw borders around the consent sections.
        public let drawBordersAroundConsents: Bool
        
        /// Creates custom styles for the standalone consent page.
        ///
        /// - Parameters:
        ///   - drawBordersAroundConsents: Whether to draw borders around the consent sections.
        public init(drawBordersAroundConsents: Bool) {
            self.drawBordersAroundConsents = drawBordersAroundConsents
        }
    }
}

// MARK: - Data

extension Aiuta.Configuration.Features.Consent.Standalone {
    /// Data provider for the standalone consent screen.
    ///
    /// Manages how consent data is stored and retrieved.
    public enum ConsentProvider {
        /// Use built-in `userDefaults` to store information about the consents
        /// obtained from the user.
        ///
        /// - Parameters:
        ///   - consents: List of consents. Any consent with `isRequired` set
        ///     to `true` must be explicitly accepted by the user to continue.
        case userDefaults(consents: [Aiuta.Consent])
        
        /// Use built-in `userDefaults` to store information about the consents
        /// obtained from the user, and provide a callback when the user has
        /// given consents and pressed the "Continue" button.
        ///
        /// - Parameters:
        ///   - consents: List of consents. Any consent with `isRequired` set
        ///     to `true` must be explicitly accepted by the user to continue.
        ///   - onObtain: Callback triggered when the user has given consents
        ///     and pressed the "Continue" button.
        case userDefaultsWithCallback(consents: [Aiuta.Consent],
                                      onObtain: ([String]) -> Void)
        
        /// Use a custom data provider for the standalone consent screen.
        ///
        /// - Parameters:
        ///   - consents: List of consents. Any consent with `isRequired` set
        ///     to `true` must be explicitly accepted by the user to continue.
        ///   - provider: Custom data provider that manages the consents,
        ///     provides obtained consent identifiers, and handles the consent
        ///     obtaining process.
        case dataProvider(consents: [Aiuta.Consent], DataProvider)
    }
}

extension Aiuta.Configuration.Features.Consent.Standalone {
    /// A protocol for providing custom data for the standalone consent feature.
    ///
    /// Implement this protocol to manage the consent data, including storing
    /// obtained consents and handling user interactions.
    public protocol DataProvider {
        /// List of consent identifiers already obtained from the user.
        @available(iOS 13.0.0, *)
        var obtainedConsentsIds: Aiuta.Observable<[String]> { get async }
        
        /// Callback triggered when the user has given consents and pressed
        /// the "Continue" button. You should store the consent identifiers and
        /// provide them in the `obtainedConsentsIds` property for future use.
        /// If not stored, the SDK will show the consent screen again during
        /// the next Try-On session.
        ///
        /// - Parameters:
        ///   - consentsIds: List of consent identifiers that the user has given.
        @available(iOS 13.0.0, *)
        func obtain(consentsIds: [String]) async
    }
}
