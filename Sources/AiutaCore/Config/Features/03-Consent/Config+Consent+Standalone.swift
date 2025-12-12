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
    /// A namespace for standalone consent page options.
    public enum Standalone {}
}

// MARK: - Strings

extension Aiuta.Configuration.Features.Consent.Standalone {
    /// Defines the text content for the standalone consent screen.
    ///
    /// You can provide custom strings or use a provider to dynamically supply
    /// the required text content.
    public enum Strings {
        /// Use custom strings for the consent page.
        ///
        /// - Parameters:
        ///   - consentPageTitle: An optional title for the standalone consent page.
        ///   - consentTitle: The main title displayed on the consent page.
        ///   - consentDescriptionHtml: The HTML content describing the consent.
        ///   - consentFooterHtml: An optional HTML footer for the consent page.
        ///   - consentButtonAccept: The text for the "Accept" button.
        ///   - consentButtonReject: Optional text for the "Reject" button. If `nil`,
        ///     the button will not be shown or used in `standaloneOnboardingPage` mode.
        case custom(consentPageTitle: String? = nil,
                    consentTitle: String,
                    consentDescriptionHtml: String,
                    consentFooterHtml: String? = nil,
                    consentButtonAccept: String,
                    consentButtonReject: String? = nil)

        /// Use a custom provider to supply the strings for the consent page.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom strings dynamically.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.Consent.Standalone.Strings {
    /// Supplies custom strings for the standalone consent page.
    ///
    /// Implement this protocol to provide the required text content for the
    /// consent page, including titles, descriptions, and button labels.
    public protocol Provider {
        /// An optional title for the standalone consent page.
        var consentPageTitle: String? { get }

        /// The main title displayed on the consent page.
        var consentTitle: String { get }

        /// The HTML content describing the consent.
        var consentDescriptionHtml: String { get }

        /// An optional HTML footer for the consent page.
        var consentFooterHtml: String? { get }

        /// The text for the "Accept" button.
        var consentButtonAccept: String { get }

        /// Optional text for the "Reject" button. If `nil`, the button will not
        /// be shown or used in `standaloneOnboardingPage` mode.
        var consentButtonReject: String? { get }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.Consent.Standalone {
    /// Defines the icons used in the standalone consent page.
    ///
    /// You can provide custom icons or use a provider to dynamically supply
    /// the required icons.
    public enum Icons {
        /// No icons are used in the consent page.
        case `default`

        /// Use custom icons for the consent page.
        ///
        /// - Parameters:
        ///   - consentTitle24: An optional icon displayed next to the consent title.
        case custom(consentTitle24: UIImage?)

        /// Use a custom provider to supply the icons for the consent page.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom icons dynamically.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.Consent.Standalone.Icons {
    /// Supplies custom icons for the standalone consent page.
    ///
    /// Implement this protocol to provide the required icons for the consent
    /// page, such as an icon displayed next to the consent title.
    public protocol Provider {
        /// An optional icon displayed next to the consent title.
        var consentTitle24: UIImage? { get }
    }
}

// MARK: - Styles

extension Aiuta.Configuration.Features.Consent.Standalone {
    /// Defines the styles used in the standalone consent screen.
    ///
    /// You can use the default styles or provide custom styles to adjust the
    /// appearance of the consent page.
    public enum Styles {
        /// Use the default styles for the consent page.
        case `default`

        /// Use custom styles for the consent page.
        ///
        /// - Parameters:
        ///   - drawBordersAroundConsents: An optional flag to draw borders
        ///     around the consent sections.
        case custom(drawBordersAroundConsents: Bool)
    }
}

// MARK: - Data

extension Aiuta.Configuration.Features.Consent.Standalone {
    /// Defines the data provider for the standalone consent screen.
    ///
    /// You can use built-in storage options or provide a custom data provider
    /// to manage the consent data.
    public enum ConsentProvider {
        /// Use built-in `userDefaults` to store information about the consents
        /// obtained from the user.
        ///
        /// - Parameters:
        ///   - consents: A list of consents. Any consent with `isRequired` set
        ///     to `true` must be explicitly accepted by the user to continue.
        case userDefaults(consents: [Aiuta.Consent])

        /// Use built-in `userDefaults` to store information about the consents
        /// obtained from the user, and provide a callback when the user has
        /// given consents and pressed the "Continue" button.
        ///
        /// - Parameters:
        ///   - consents: A list of consents. Any consent with `isRequired` set
        ///     to `true` must be explicitly accepted by the user to continue.
        ///   - onObtain: A callback triggered when the user has given consents
        ///     and pressed the "Continue" button.
        case userDefaultsWithCallback(consents: [Aiuta.Consent],
                                      onObtain: ([String]) -> Void)

        /// Use a custom data provider for the standalone consent screen.
        ///
        /// - Parameters:
        ///   - consents: A list of consents. Any consent with `isRequired` set
        ///     to `true` must be explicitly accepted by the user to continue.
        ///   - provider: A custom data provider that manages the consents,
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
        /// A list of consent identifiers already obtained from the user.
        @available(iOS 13.0.0, *)
        var obtainedConsentsIds: Aiuta.Observable<[String]> { get async }

        /// A callback triggered when the user has given consents and pressed
        /// the "Continue" button. You should store the consent identifiers and
        /// provide them in the `obtainedConsentsIds` property for future use.
        /// If not stored, the SDK will show the consent screen again during
        /// the next Try-On session.
        ///
        /// - Parameters:
        ///   - consentsIds: A list of consent identifiers that the user has given.
        @available(iOS 13.0.0, *)
        func obtain(consentsIds: [String]) async
    }
}
