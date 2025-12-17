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
    /// Configures the onboarding process.
    ///
    /// Onboarding helps guide users through the SDK's functionality. You can use
    /// the default configuration, customize it to fit your app's needs, or disable
    /// onboarding entirely.
    public enum Onboarding {
        /// Use the default onboarding configuration.
        case `default`

        /// Disable the onboarding feature.
        case none

        /// Use a custom onboarding configuration.
        ///
        /// - Parameters:
        ///   - howItWorks: Configures the "How It Works" page, that is the first page of the onboarding.
        ///                 It interactively shows the user how the virtual try-on looks like.
        ///   - bestResults: Configures the "Best Results" page of onboarding.
        ///                  This page is shown after the `howItWorks` page and provides
        ///                  examples of the photos to achieve the best results.
        ///                  It is recommended to not include this page in the onboarding
        ///                  as the Image Picker page also has examples of the photos
        ///                  to achieve the best results for the try-on.
        ///   - strings: Configures the text content for onboarding.
        ///   - shapes: Configures the shapes used in onboarding image views.
        ///   - data: Configures the provider for storing onboarding completion status.
        case custom(howItWorks: HowItWorks = .default,
                    bestResults: BestResults = .none,
                    strings: Strings = .default,
                    shapes: Shapes = .inherited,
                    data: StateProvider = .userDefaults)
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.Onboarding {
    /// Configures the text content for onboarding.
    ///
    /// This includes strings for buttons to navigate through the onboarding process.
    public enum Strings {
        /// Use the default text content for onboarding.
        case `default`

        /// Use custom text content for onboarding.
        ///
        /// - Parameters:
        ///   - onboardingButtonNext: The text for the "Next" button.
        ///   - onboardingButtonStart: The text for the "Start" button.
        case custom(onboardingButtonNext: String,
                    onboardingButtonStart: String)

        /// Use a custom strings provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom strings for onboarding.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.Onboarding.Strings {
    /// Supplies custom text content for onboarding.
    ///
    /// - Note: Use the `Aiuta.Configuration.Strings` typealias for convenience.
    public protocol Provider {
        /// The text for the "Next" button in onboarding.
        var onboardingButtonNext: String { get }

        /// The text for the "Start" button in onboarding.
        var onboardingButtonStart: String { get }
    }
}

// MARK: - Shapes

extension Aiuta.Configuration.Features.Onboarding {
    /// Configures the shapes used in onboarding image views.
    ///
    /// Shapes define the visual appearance of image containers in onboarding.
    public enum Shapes {
        /// Use the default shapes inherited from the image theme.
        case inherited

        /// Use custom shapes for onboarding image views.
        ///
        /// - Parameters:
        ///   - onboardingImageL: The shape for large image views.
        ///   - onboardingImageS: The shape for small image views.
        case custom(onboardingImageL: Aiuta.Configuration.Shape,
                    onboardingImageS: Aiuta.Configuration.Shape)

        /// Use a custom shapes provider.
        ///
        /// - Parameters:
        ///   - provider: Supplies the custom shapes for onboarding.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.Onboarding.Shapes {
    /// Supplies custom shapes for onboarding image views.
    ///
    /// - Note: Use the `Aiuta.Configuration.Shapes` typealias for convenience.
    public protocol Provider {
        /// The shape for large image views in onboarding.
        var onboardingImageL: Aiuta.Configuration.Shape { get }

        /// The shape for small image views in onboarding.
        var onboardingImageS: Aiuta.Configuration.Shape { get }
    }
}

// MARK: - DataProvider

extension Aiuta.Configuration.Features.Onboarding {
    /// Configures the provider for storing onboarding completion status.
    ///
    /// This determines how the SDK tracks whether a user has completed onboarding.
    public enum StateProvider {
        /// Use the built-in `userDefaults` provider to store onboarding completion
        /// status.
        case userDefaults

        /// Use a custom provider for onboarding completion status.
        ///
        /// - Parameters:
        ///   - dataProvider: Supplies the custom logic for storing and retrieving
        ///     onboarding completion status.
        case dataProvider(DataProvider)
    }
}

extension Aiuta.Configuration.Features.Onboarding {
    /// Supplies custom logic for storing and retrieving onboarding completion status.
    ///
    /// This protocol allows you to define how the SDK tracks whether onboarding
    /// has been completed.
    public protocol DataProvider {
        /// Indicates whether onboarding has been completed.
        @available(iOS 13.0.0, *)
        var isOnboardingCompleted: Bool { get async }

        /// Marks onboarding as completed.
        @available(iOS 13.0.0, *)
        func completeOnboarding() async
    }
}
