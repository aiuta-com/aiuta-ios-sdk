// Copyright 2024 Aiuta USA, Inc
//
// Licensed under the Apache License, Version 2.0 (the "License");
// You may not use this file except in compliance with the License.
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
    /// Configures the BestResults page for onboarding.
    ///
    /// The BestResults page provides guidance to help users achieve optimal
    /// results when using the Try-On feature. You can disable this page or
    /// customize it to better fit your app's requirements.
    public enum BestResults {
        /// Disables the BestResults page.
        ///
        /// This is recommended since best result samples are already included
        /// in the Image Picker.
        case none

        /// Enables the BestResults page with a custom configuration.
        ///
        /// - Parameters:
        ///   - images: Defines the images displayed on the BestResults page.
        ///   - icons: Defines the icons used on the BestResults page.
        ///   - strings: Defines the text content for the BestResults page.
        ///   - toggles: Configures additional settings for the BestResults page.
        case custom(images: Images,
                    icons: Icons,
                    strings: Strings,
                    toggles: Toggles = .default)
    }
}

// MARK: - Images

extension Aiuta.Configuration.Features.Onboarding.BestResults {
    /// Configures the images used on the BestResults page.
    public enum Images {
        /// Uses custom images for the BestResults page.
        ///
        /// - Parameters:
        ///   - onboardingBestResultsGood: A list of exactly 2 images representing
        ///                                good examples for achieving the best results.
        ///   - onboardingBestResultsBad: A list of exactly 2 images representing
        ///                               bad examples to avoid.
        case custom(onboardingBestResultsGood: [UIImage],
                    onboardingBestResultsBad: [UIImage])

        /// Uses a custom image provider for the BestResults page.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom images for the page.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.Onboarding.BestResults.Images {
    public protocol Provider {
        /// A list of exactly 2 images representing good examples.
        var onboardingBestResultsGood: [UIImage] { get }
        /// A list of exactly 2 images representing bad examples.
        var onboardingBestResultsBad: [UIImage] { get }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.Onboarding.BestResults {
    /// Configures the icons used on the BestResults page.
    public enum Icons {
        /// Uses custom icons for the BestResults page.
        ///
        /// - Parameters:
        ///   - onboardingBestResultsGood24: An icon for good examples.
        ///   - onboardingBestResultsBad24: An icon for bad examples.
        case custom(onboardingBestResultsGood24: UIImage,
                    onboardingBestResultsBad24: UIImage)

        /// Uses a custom icon provider for the BestResults page.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom icons for the page.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.Onboarding.BestResults.Icons {
    public protocol Provider {
        /// An icon for good examples.
        var onboardingBestResultsGood24: UIImage { get }
        /// An icon for bad examples.
        var onboardingBestResultsBad24: UIImage { get }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.Onboarding.BestResults {
    /// Configures the text content for the BestResults page.
    public enum Strings {
        /// Uses custom text content for the BestResults page.
        ///
        /// - Parameters:
        ///   - onboardingBestResultsPageTitle: An optional title for the page.
        ///   - onboardingBestResultsTitle: The title displayed below the best
        ///     results samples.
        ///   - onboardingBestResultsDescription: A description explaining how
        ///     to achieve the best results.
        case custom(onboardingBestResultsPageTitle: String?,
                    onboardingBestResultsTitle: String,
                    onboardingBestResultsDescription: String)

        /// Uses a custom strings provider for the BestResults page.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom text content for the page.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.Onboarding.BestResults.Strings {
    /// Supplies custom text content for the BestResults page.
    ///
    /// This protocol allows you to define the text displayed on the page,
    /// including titles and descriptions.
    public protocol Provider {
        /// An optional title for the BestResults page.
        var onboardingBestResultsPageTitle: String? { get }

        /// The title displayed below the best results samples.
        var onboardingBestResultsTitle: String { get }

        /// A description explaining how to achieve the best results.
        var onboardingBestResultsDescription: String { get }
    }
}

// MARK: - Toggles

extension Aiuta.Configuration.Features.Onboarding.BestResults {
    /// Configures additional settings for the BestResults page.
    public enum Toggles {
        /// Uses the default settings for the BestResults page.
        case `default`

        /// Uses custom settings for the BestResults page.
        ///
        /// - Parameters:
        ///   - reduceShadows: An optional setting to reduce shadows on the page.
        case custom(reduceShadows: Bool)
    }
}
