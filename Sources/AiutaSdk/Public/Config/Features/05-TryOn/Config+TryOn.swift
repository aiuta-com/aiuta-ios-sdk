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

extension Aiuta.Configuration.Features {
    /// Configures the TryOn feature. This feature allows you to customize the
    /// behavior, appearance, and functionality of the TryOn experience, such as
    /// icons, styles, strings, and toggles.
    public enum TryOn {
        /// Use the default configuration for the TryOn feature.
        case `default`

        /// Use a custom configuration for the TryOn feature.
        ///
        /// - Parameters:
        ///   - loadingPage: Configuration for the loading page displayed during
        ///                  the TryOn process.
        ///   - inputImageValidation: Configuration for validating input images.
        ///   - cart: Configuration for cart-related functionality.
        ///   - fitDisclaimer: Configuration for displaying fit disclaimers.
        ///   - feedback: Configuration for user feedback options.
        ///   - generationsHistory: Configuration for managing the history of
        ///                         generated TryOn results.
        ///   - otherPhoto: Configuration for continuing with a different photo.
        ///   - icons: Custom icons for the TryOn feature.
        ///   - styles: Custom styles for the TryOn feature.
        ///   - strings: Custom text content for the TryOn feature.
        ///   - toggles: Custom toggles for enabling or disabling specific
        ///              TryOn behaviors.
        case custom(loadingPage: LoadingPage = .default,
                    inputImageValidation: InputValidation = .default,
                    cart: Cart,
                    fitDisclaimer: FitDisclaimer = .default,
                    feedback: Feedback = .default,
                    generationsHistory: GenerationsHistory = .default,
                    otherPhoto: ContinueWithOtherPhoto = .default,
                    icons: Icons = .builtIn,
                    styles: Styles = .default,
                    strings: Strings = .default,
                    toggles: Toggles = .default)
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.TryOn {
    /// Defines the icons used in the TryOn feature. You can use default icons,
    /// provide custom ones, or supply them dynamically through a provider.
    public enum Icons {
        /// Use the default set of icons provided by the SDK.
        case builtIn

        /// Specify custom icons for the TryOn feature.
        ///
        /// - Parameters:
        ///   - magic20: The icon displayed for the TryOn magic button.
        case custom(magic20: UIImage)

        /// Use a custom provider to supply icons dynamically.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom icons.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.TryOn.Icons {
    /// A protocol for supplying custom icons to the TryOn feature. Implement
    /// this protocol to provide a custom set of icons dynamically.
    public protocol Provider {
        /// The icon displayed for the TryOn magic button.
        var magic20: UIImage { get }
    }
}

// MARK: - Styles

extension Aiuta.Configuration.Features.TryOn {
    /// Defines the styles used in the TryOn feature. You can use default styles
    /// or provide custom ones to adjust the appearance of the interface.
    public enum Styles {
        /// Use the default styles provided by the SDK.
        case `default`

        /// Specify custom styles for the TryOn feature.
        ///
        /// - Parameters:
        ///   - tryOnButtonGradient: The gradient style for the TryOn magic button.
        case custom(tryOnButtonGradient: [UIColor])
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.TryOn {
    /// Defines the text content used in the TryOn feature. You can use default
    /// text, provide custom strings, or supply them dynamically through a provider.
    public enum Strings {
        /// Use the default text content provided by the SDK.
        case `default`

        /// Specify custom text content for the TryOn feature.
        ///
        /// - Parameters:
        ///   - tryOnPageTitle: The title displayed on the TryOn page.
        ///   - tryOn: The label for the "Try On" buttons.
        case custom(tryOnPageTitle: String,
                    tryOn: String)

        /// Use a custom provider to supply text content.
        ///
        /// - Parameters:
        ///   - provider: A provider that supplies the custom text content.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.TryOn.Strings {
    /// A protocol for supplying custom text content to the TryOn feature.
    public protocol Provider {
        /// The title displayed on the TryOn page.
        var tryOnPageTitle: String { get }

        /// The label for the "Try On" button.
        var tryOn: String { get }
    }
}

// MARK: - Toggles

extension Aiuta.Configuration.Features.TryOn {
    /// Configures specific settings for the TryOn feature.
    public enum Toggles {
        /// Use the default settings for the TryOn feature.
        case `default`

        /// Specify custom settings for the BestResults onboarding page.
        ///
        /// - Parameters:
        ///   - allowsBackgroundExecution: Determines whether the SDK should
        ///     continue tracking the generation process in the background when
        ///     the user closes the SDK. If disabled, the SDK will stop tracking
        ///     the operation and halt all activity upon closing. Note that the
        ///     Aiuta backend will still complete the operation even if the SDK
        ///     stops tracking it.
        ///   - tryGeneratePersonSegmentation: While waiting for the try-on result,
        ///     try to highlight the human outline using iOS system tools on the
        ///     animation screen. Works locally. iOS 15+. In case of failure,
        ///     the regular animation of the loader will not be affected.
        case custom(allowsBackgroundExecution: Bool,
                    tryGeneratePersonSegmentation: Bool)
    }
}
