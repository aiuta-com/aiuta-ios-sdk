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
    /// Configuration for embedded consent into onboarding pages.
    public struct Embedded: Sendable {
        /// Text content for the consent embedded into the onboarding screen.
        public let strings: Strings
        
        /// Creates an embedded consent configuration.
        ///
        /// - Parameters:
        ///   - strings: Text content for the consent embedded into the onboarding screen.
        public init(strings: Strings) {
            self.strings = strings
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.Consent.Embedded {
    /// Text content for the consent embedded into the onboarding screen.
    public struct Strings: Sendable {
        /// HTML content representing the consent information.
        ///
        /// This content is displayed at the bottom of the onboarding screen
        /// and should include concise text and links to the privacy policy
        /// and/or terms of service within the HTML attribute.
        public let consentHtml: String
        
        /// Creates custom HTML content for embedded consent.
        ///
        /// - Parameters:
        ///   - consentHtml: HTML content representing the consent information.
        public init(consentHtml: String) {
            self.consentHtml = consentHtml
        }
        
        /// Creates consent with a terms of service URL.
        ///
        /// Uses the default strings provided by the SDK with a link to your terms of service.
        ///
        /// - Parameters:
        ///   - termsOfServiceUrl: URL to the terms of service page.
        public static func `default`(termsOfServiceUrl: String) -> Strings {
            return Strings(consentHtml: termsOfServiceUrl)
        }
    }
}
