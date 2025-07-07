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
    /// Configures the "How It Works" page for onboarding.
    ///
    /// This page explains how the Try-On feature works. You can use the default
    /// configuration or customize it to fit your app's needs.
    public enum HowItWorks {
        /// Use the default configuration for the "How It Works" page.
        case `default`

        /// Use a custom configuration for the "How It Works" page.
        ///
        /// - Parameters:
        ///   - images: Defines the images displayed on the "How It Works" page.
        ///   - strings: Defines the text content for the "How It Works" page.
        case custom(images: Images = .builtIn,
                    strings: Strings = .default)
    }
}

// MARK: - Images

extension Aiuta.Configuration.Features.Onboarding.HowItWorks {
    /// Configures the images used on the "How It Works" page.
    public enum Images {
        /// Use the default images provided by the SDK.
        case builtIn

        /// Use custom images for the "How It Works" page.
        ///
        /// - Parameters:
        ///   - onboardingHowItWorksItems: An array of exactly 3 `Images.Item`
        ///     objects, each containing images for the interactive onboarding.
        case custom(onboardingHowItWorksItems: [Item])

        /// Use a custom image provider for the "How It Works" page.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom images for the page.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.Onboarding.HowItWorks.Images {
    /// Represents an item used to provide images for the "How It Works" page.
    public struct Item {
        /// The example image for the Try-On feature.
        ///
        /// All images should depict the same person in the same pose wearing
        /// `itemPreview`. It is recommended to generate these images using Aiuta.
        let itemPhoto: UIImage

        /// The flatlay image of the item with a transparent background.
        let itemPreview: UIImage
        
        /// Initializes a new `Item` with the specified images.
        public init(itemPhoto: UIImage, itemPreview: UIImage) {
            self.itemPhoto = itemPhoto
            self.itemPreview = itemPreview
        }
    }

    /// Supplies custom images for the "How It Works" page.
    ///
    /// This protocol allows you to define how images are provided for the
    /// interactive onboarding experience.
    public protocol Provider {
        /// An array of `HowItWorksItem` objects, each containing sample photo
        /// and item preview. The array must contain exactly 3 items.
        var onboardingHowItWorksItems: [Item] { get }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.Onboarding.HowItWorks {
    /// Configures the text content for the "How It Works" page.
    public enum Strings {
        /// Use the default text content for the "How It Works" page.
        case `default`

        /// Use custom text content for the "How It Works" page.
        ///
        /// - Parameters:
        ///   - onboardingHowItWorksPageTitle: An optional title for the page.
        ///   - onboardingHowItWorksTitle: The title displayed below the interactive
        ///     onboarding section.
        ///   - onboardingHowItWorksDescription: A description explaining how the
        ///     Try-On feature works.
        case custom(onboardingHowItWorksPageTitle: String?,
                    onboardingHowItWorksTitle: String,
                    onboardingHowItWorksDescription: String)

        /// Use a custom strings provider for the "How It Works" page.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom text content for the page.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.Onboarding.HowItWorks.Strings {
    /// Supplies custom text content for the "How It Works" page.
    ///
    /// This protocol allows you to define the text displayed on the page.
    public protocol Provider {
        /// An optional title for the "How It Works" page.
        var onboardingHowItWorksPageTitle: String? { get }

        /// The title displayed below the interactive onboarding section.
        var onboardingHowItWorksTitle: String { get }

        /// A description explaining how the Try-On feature works.
        var onboardingHowItWorksDescription: String { get }
    }
}
