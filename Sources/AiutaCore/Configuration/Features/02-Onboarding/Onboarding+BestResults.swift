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

extension Aiuta.Configuration.Features.Onboarding {
    /// "Best Results" page configuration for onboarding.
    ///
    /// The BestResults page provides guidance to help users achieve optimal
    /// results when using the Try-On feature.
    ///
    /// **Note:** It's recommended to skip this page (set to `nil`) since best result
    /// samples are already included in the Image Picker.
    public struct BestResults: Sendable {
        /// Images displayed on the BestResults page.
        public let images: Images
        
        /// Icons used on the BestResults page.
        public let icons: Icons
        
        /// Text content for the BestResults page.
        public let strings: Strings
        
        /// Additional settings for the BestResults page.
        public let toggles: Toggles
        
        /// Creates a custom BestResults page configuration.
        ///
        /// - Parameters:
        ///   - images: Images displayed on the BestResults page.
        ///   - icons: Icons used on the BestResults page.
        ///   - strings: Text content for the BestResults page.
        ///   - toggles: Additional settings for the BestResults page.
        public init(images: Images,
                    icons: Icons,
                    strings: Strings,
                    toggles: Toggles) {
            self.images = images
            self.icons = icons
            self.strings = strings
            self.toggles = toggles
        }
    }
}

// MARK: - Images

extension Aiuta.Configuration.Features.Onboarding.BestResults {
    /// Images used on the BestResults page.
    public struct Images: Sendable {
        /// List of exactly 2 images representing good examples for achieving the best results.
        public let onboardingBestResultsGood: [UIImage]
        
        /// List of exactly 2 images representing bad examples to avoid.
        public let onboardingBestResultsBad: [UIImage]
        
        /// Creates custom images.
        ///
        /// - Parameters:
        ///   - onboardingBestResultsGood: List of exactly 2 images representing good examples for achieving the best results.
        ///   - onboardingBestResultsBad: List of exactly 2 images representing bad examples to avoid.
        public init(onboardingBestResultsGood: [UIImage],
                    onboardingBestResultsBad: [UIImage]) {
            self.onboardingBestResultsGood = onboardingBestResultsGood
            self.onboardingBestResultsBad = onboardingBestResultsBad
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.Onboarding.BestResults {
    /// Icons used on the BestResults page.
    public struct Icons: Sendable {
        /// Icon for good examples (24x24).
        public let onboardingBestResultsGood24: UIImage
        
        /// Icon for bad examples (24x24).
        public let onboardingBestResultsBad24: UIImage
        
        /// Creates custom icons.
        ///
        /// - Parameters:
        ///   - onboardingBestResultsGood24: Icon for good examples (24x24).
        ///   - onboardingBestResultsBad24: Icon for bad examples (24x24).
        public init(onboardingBestResultsGood24: UIImage,
                    onboardingBestResultsBad24: UIImage) {
            self.onboardingBestResultsGood24 = onboardingBestResultsGood24
            self.onboardingBestResultsBad24 = onboardingBestResultsBad24
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.Onboarding.BestResults {
    /// Text content for the BestResults page.
    public struct Strings: Sendable {
        /// Optional title for the page (displayed at the top).
        public let onboardingBestResultsPageTitle: String?
        
        /// Title displayed below the best results samples.
        public let onboardingBestResultsTitle: String
        
        /// Description explaining how to achieve the best results.
        public let onboardingBestResultsDescription: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - onboardingBestResultsPageTitle: Optional title for the page (displayed at the top).
        ///   - onboardingBestResultsTitle: Title displayed below the best results samples.
        ///   - onboardingBestResultsDescription: Description explaining how to achieve the best results.
        public init(onboardingBestResultsPageTitle: String?,
                    onboardingBestResultsTitle: String,
                    onboardingBestResultsDescription: String) {
            self.onboardingBestResultsPageTitle = onboardingBestResultsPageTitle
            self.onboardingBestResultsTitle = onboardingBestResultsTitle
            self.onboardingBestResultsDescription = onboardingBestResultsDescription
        }
    }
}

// MARK: - Toggles

extension Aiuta.Configuration.Features.Onboarding.BestResults {
    /// Additional settings for the BestResults page.
    public struct Toggles: Sendable {
        /// Whether to reduce shadows on the page.
        public let reduceShadows: Bool
        
        /// Creates custom settings.
        ///
        /// - Parameters:
        ///   - reduceShadows: Whether to reduce shadows on the page.
        public init(reduceShadows: Bool) {
            self.reduceShadows = reduceShadows
        }
    }
}
