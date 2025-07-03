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

extension Aiuta {
    /// Represents the consent information required by the SDK.
    /// This includes details about the consent type, its unique identifier,
    /// and the HTML content that describes the consent.
    public struct Consent {
        /// A unique identifier for the consent.
        public let id: String

        /// Specifies how the consent is obtained, such as implicit or explicit.
        public let type: ObtainType

        /// The HTML content that provides detailed information about the consent.
        /// This may include links to relevant documents or policies.
        public let html: String

        /// Creates a `Consent` with the specified parameters.
        ///
        /// - Parameters:
        ///   - id: A unique identifier for the consent.
        ///   - type: The method used to obtain the consent.
        ///   - html: The HTML content describing the consent.
        public init(id: String, type: ObtainType, html: String) {
            self.id = id
            self.type = type
            self.html = html
        }
    }
}

extension Aiuta.Consent {
    /// Defines the methods for obtaining consent to process user photos.
    /// This includes implicit consent (e.g., pressing an `Accept` button)
    /// and explicit consent (e.g., checking a checkbox).
    public enum ObtainType {
        /// Represents implicit consent, where the user provides consent
        /// by pressing an `Accept` button, not check box. This may optionally
        /// include a disabled (pre-selected) checkbox for additional clarity.
        ///
        /// - Parameters:
        ///  - hasCheckBox: A Boolean value indicating whether the consent has a checkbox
        ///                 that is pre-selected and can't be unchecked (disabled).
        ///
        /// - Note: It can be just an `Accept` button, but only if it’s very clear exactly
        ///         what the user is consenting to at that moment and you can’t bundle
        ///         multiple consents into one `Accept` unless they’re strictly necessary.
        ///         For example, GDPR says marketing consent should always be separate if possible.
        ///
        ///         This can be used only for the consent that is necessary for the service,
        ///         as it’s not really “consent” under GDPR and it’s processing based on
        ///         contract necessity (Article 6(1)(b)) or legal obligation, not based on
        ///         “freely given consent” (Article 6(1)(a)), so, it is just informing the users,
        ///         not asking them for an additional permission.
        ///
        ///         Please consider that this option at all (with or w/o checkbox)
        ///         is not valid for all cases, and it should be used with caution.
        ///         Consult with a legal department if in doubt.
        case implicit(hasCheckBox: Bool)

        /// Represents explicit consent, where the user must actively check
        /// a checkbox to provide consent. This is required for cases where
        /// consent must be freely given and unambiguous.
        ///
        /// - Parameters:
        ///   - isRequired: Indicates whether the checkbox must be checked
        ///     to proceed with the action.
        ///
        /// - Note: Pre-selected checkboxes are not valid under GDPR, even if
        ///         the user presses an `Accept` button. The checkbox must be
        ///         explicitly selected by the user.
        case explicit(isRequired: Bool)
    }
}
