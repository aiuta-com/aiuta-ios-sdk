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
    /// Onboarding helps guide users through the SDK's functionality.
    /// To disable this feature, set it to `nil` in the `Features` configuration.
    public struct Onboarding: Sendable {
        /// "How It Works" page configuration (first page of onboarding).
        public let howItWorks: HowItWorks
        
        /// "Best Results" page configuration (shown after "How It Works").
        /// Set to `nil` to skip this page (recommended, as Image Picker already has examples).
        public let bestResults: BestResults?
        
        /// Text content for onboarding navigation buttons.
        public let strings: Strings
        
        /// Shapes used in onboarding image views.
        public let shapes: Shapes
        
        /// Provider for storing onboarding completion status.
        public let data: StateProvider
        
        /// Creates a custom onboarding configuration.
        ///
        /// - Parameters:
        ///   - howItWorks: "How It Works" page configuration (first page of onboarding).
        ///   - bestResults: "Best Results" page configuration (shown after "How It Works"). Set to `nil` to skip this page (recommended, as Image Picker already has examples).
        ///   - strings: Text content for onboarding navigation buttons.
        ///   - shapes: Shapes used in onboarding image views.
        ///   - data: Provider for storing onboarding completion status.
        public init(howItWorks: HowItWorks,
                    bestResults: BestResults?,
                    strings: Strings,
                    shapes: Shapes,
                    data: StateProvider) {
            self.howItWorks = howItWorks
            self.bestResults = bestResults
            self.strings = strings
            self.shapes = shapes
            self.data = data
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.Onboarding {
    /// Text content for onboarding navigation buttons.
    public struct Strings: Sendable {
        /// Text for the "Next" button.
        public let onboardingButtonNext: String
        
        /// Text for the "Start" button.
        public let onboardingButtonStart: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - onboardingButtonNext: Text for the "Next" button.
        ///   - onboardingButtonStart: Text for the "Start" button.
        public init(onboardingButtonNext: String,
                    onboardingButtonStart: String) {
            self.onboardingButtonNext = onboardingButtonNext
            self.onboardingButtonStart = onboardingButtonStart
        }
    }
}

// MARK: - Shapes

extension Aiuta.Configuration.Features.Onboarding {
    /// Shapes used in onboarding image views.
    public struct Shapes: Sendable {
        /// Shape for large image views.
        public let onboardingImageL: Aiuta.Configuration.Shape
        
        /// Shape for small image views.
        public let onboardingImageS: Aiuta.Configuration.Shape
        
        /// Creates custom shapes.
        ///
        /// - Parameters:
        ///   - onboardingImageL: Shape for large image views.
        ///   - onboardingImageS: Shape for small image views.
        public init(onboardingImageL: Aiuta.Configuration.Shape,
                    onboardingImageS: Aiuta.Configuration.Shape) {
            self.onboardingImageL = onboardingImageL
            self.onboardingImageS = onboardingImageS
        }
        
        /// Uses shapes inherited from the image theme.
        public static let inherited = Shapes(
            onboardingImageL: .continuous(radius: 0),
            onboardingImageS: .continuous(radius: 0)
        )
    }
}

// MARK: - StateProvider

extension Aiuta.Configuration.Features.Onboarding {
    /// Provider for storing onboarding completion status.
    ///
    /// This determines how the SDK tracks whether a user has completed onboarding.
    public enum StateProvider {
        /// Use the built-in `userDefaults` provider to store onboarding completion status.
        case userDefaults
        
        /// Use a custom provider for onboarding completion status.
        ///
        /// - Parameters:
        ///   - dataProvider: Custom logic for storing and retrieving onboarding completion status.
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
