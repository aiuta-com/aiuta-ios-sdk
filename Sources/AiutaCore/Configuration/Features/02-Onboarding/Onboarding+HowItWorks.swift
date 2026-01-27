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
    /// "How It Works" page configuration for onboarding.
    ///
    /// This page explains how the Try-On feature works through interactive examples.
    public struct HowItWorks: Sendable {
        /// Images displayed on the "How It Works" page.
        public let images: Images
        
        /// Text content for the "How It Works" page.
        public let strings: Strings
        
        /// Creates a custom "How It Works" page configuration.
        ///
        /// - Parameters:
        ///   - images: Images displayed on the "How It Works" page.
        ///   - strings: Text content for the "How It Works" page.
        public init(images: Images,
                    strings: Strings) {
            self.images = images
            self.strings = strings
        }
    }
}

// MARK: - Images

extension Aiuta.Configuration.Features.Onboarding.HowItWorks {
    /// Images used on the "How It Works" page.
    public struct Images: Sendable {
        /// Array of exactly 3 items, each containing images for the interactive onboarding.
        public let onboardingHowItWorksItems: [Item]
        
        /// Creates custom images.
        ///
        /// - Parameters:
        ///   - onboardingHowItWorksItems: Array of exactly 3 items, each containing images for the interactive onboarding.
        public init(onboardingHowItWorksItems: [Item]) {
            self.onboardingHowItWorksItems = onboardingHowItWorksItems
        }
    }
}

extension Aiuta.Configuration.Features.Onboarding.HowItWorks.Images {
    /// Represents an item with images for the "How It Works" interactive onboarding.
    public struct Item: Sendable {
        /// Try-On result image.
        ///
        /// All images should depict the same person in the same pose wearing
        /// `itemPreview`. It is recommended to generate these images using Aiuta.
        public let itemPhoto: UIImage
        
        /// Flatlay image of the item with a transparent background.
        public let itemPreview: UIImage
        
        /// Creates a new item with the specified images.
        ///
        /// - Parameters:
        ///   - itemPhoto: Try-On result image.
        ///   - itemPreview: Flatlay image of the item with a transparent background.
        public init(itemPhoto: UIImage, itemPreview: UIImage) {
            self.itemPhoto = itemPhoto
            self.itemPreview = itemPreview
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.Onboarding.HowItWorks {
    /// Text content for the "How It Works" page.
    public struct Strings: Sendable {
        /// Optional title for the page (displayed at the top).
        public let onboardingHowItWorksPageTitle: String?
        
        /// Title displayed below the interactive onboarding section.
        public let onboardingHowItWorksTitle: String
        
        /// Description explaining how the Try-On feature works.
        public let onboardingHowItWorksDescription: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - onboardingHowItWorksPageTitle: Optional title for the page (displayed at the top).
        ///   - onboardingHowItWorksTitle: Title displayed below the interactive onboarding section.
        ///   - onboardingHowItWorksDescription: Description explaining how the Try-On feature works.
        public init(onboardingHowItWorksPageTitle: String?,
                    onboardingHowItWorksTitle: String,
                    onboardingHowItWorksDescription: String) {
            self.onboardingHowItWorksPageTitle = onboardingHowItWorksPageTitle
            self.onboardingHowItWorksTitle = onboardingHowItWorksTitle
            self.onboardingHowItWorksDescription = onboardingHowItWorksDescription
        }
    }
}
