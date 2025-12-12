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

extension Aiuta.Configuration.Features {
    /// Configures user consent options for data processing.
    ///
    /// This feature allows you to define how consent is presented to users. Consent
    /// can be integrated into onboarding, displayed as a standalone page, or shown
    /// in a bottom sheet when specific actions are performed. You can choose the
    /// option that best fits your app's flow.
    public enum Consent {
        /// No consent is required.
        case none

        /// Embeds consent information into the onboarding pages.
        ///
        /// The consent details are displayed at the bottom of the onboarding screen.
        /// Users are not required to explicitly accept the terms and conditions to
        /// proceed.
        ///
        /// - Parameters:
        ///   - strings: Configures the text content for the embedded consent screen.
        case embeddedIntoOnboarding(strings: Embedded.Strings)

        /// Displays consent information as a standalone page.
        ///
        /// This page appears after onboarding (if enabled) or as a separate page
        /// otherwise. Users must accept the terms by selecting the required checkboxes
        /// to continue.
        ///
        /// - Parameters:
        ///   - strings: Configures the text content for the standalone consent screen.
        ///   - icons: Configures the icons used in the standalone consent screen.
        ///   - styles: Configures the visual styles for the standalone consent screen.
        ///   - data: Configures the consent provider that manages consent options.
        case standaloneOnboardingPage(strings: Standalone.Strings,
                                      icons: Standalone.Icons = .default,
                                      styles: Standalone.Styles = .default,
                                      data: Standalone.ConsentProvider)

        /// Displays consent information in a bottom sheet during photo upload.
        ///
        /// This bottom sheet appears when users attempt to upload a photo in the
        /// image picker. Users must accept the terms by selecting the required
        /// checkboxes to proceed.
        ///
        /// - Parameters:
        ///   - strings: Configures the text content for the bottom sheet consent screen.
        ///   - icons: Configures the icons used in the bottom sheet consent screen.
        ///   - styles: Configures the visual styles for the bottom sheet consent screen.
        ///   - data: Configures the consent provider that manages consent options.
        case standaloneImagePickerPage(strings: Standalone.Strings,
                                        icons: Standalone.Icons = .default,
                                        styles: Standalone.Styles = .default,
                                        data: Standalone.ConsentProvider)
    }
}
