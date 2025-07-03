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

import Foundation

extension Aiuta.Configuration.Features.Consent {
    /// A namespace for embedded into onboaring consent options.
    public enum Embedded {}
}

// MARK: - Strings

extension Aiuta.Configuration.Features.Consent.Embedded {
    /// Configures the text content for the consent embedded into the onboarding screen.
    ///
    /// You can provide custom HTML content or use a custom provider to supply
    /// the required strings.
    public enum Strings {
        /// Use custom HTML content for the consent embedded into the onboarding screen.
        ///
        /// - Parameters:
        ///   - consentHtml: The HTML content that represents the consent
        ///     information. This content is displayed at the bottom of the onboarding
        ///     screen and should include concise text and links to the privacy policy
        ///     and/or terms of service within the HTML attribute.
        case custom(consentHtml: String)

        /// Use a custom provider to supply the strings for the consent screen.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom strings for the consent screen.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.Consent.Embedded.Strings {
    /// Supplies custom strings for the embedded consent screen.
    ///
    /// Implement this protocol to provide the HTML content required for the
    /// consent embedded into the onboarding screen.
    public protocol Provider {
        /// The HTML content that represents the consent information.
        ///
        /// This content is displayed at the bottom of the onboarding screen
        /// and should include concise text and links to the privacy policy
        /// and/or terms of service within the HTML attribute.
        var consentHtml: String { get }
    }
}
