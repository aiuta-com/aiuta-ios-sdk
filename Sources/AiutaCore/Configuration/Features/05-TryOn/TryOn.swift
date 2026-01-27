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
    /// TryOn feature configuration.
    ///
    /// Customize the behavior, appearance, and functionality of the TryOn experience.
    public struct TryOn: Sendable {
        /// Loading page configuration during the TryOn process.
        public let loadingPage: LoadingPage
        
        /// Input image validation configuration.
        public let inputImageValidation: InputValidation
        
        /// Cart functionality configuration. Set to `nil` to disable cart functionality.
        public let cart: Cart?
        
        /// Fit disclaimer configuration. Set to `nil` to disable.
        public let fitDisclaimer: FitDisclaimer?
        
        /// User feedback options configuration. Set to `nil` to disable.
        public let feedback: Feedback?
        
        /// Generated TryOn results history configuration. Set to `nil` to disable.
        public let generationsHistory: GenerationsHistory?
        
        /// Continue with different photo configuration.
        public let otherPhoto: ContinueWithOtherPhoto
        
        /// TryOn magic button icon.
        public let icons: Icons
        
        /// Visual styles for TryOn interface.
        public let styles: Styles
        
        /// Text content for TryOn interface.
        public let strings: Strings
        
        /// Settings for enabling or disabling specific TryOn behaviors.
        public let toggles: Toggles
        
        /// Creates a custom TryOn configuration.
        ///
        /// - Parameters:
        ///   - loadingPage: Loading page configuration during the TryOn process.
        ///   - inputImageValidation: Input image validation configuration.
        ///   - cart: Cart functionality configuration. Set to `nil` to disable cart functionality.
        ///   - fitDisclaimer: Fit disclaimer configuration.
        ///   - feedback: User feedback options configuration.
        ///   - generationsHistory: Generated TryOn results history configuration.
        ///   - otherPhoto: Continue with different photo configuration.
        ///   - icons: TryOn magic button icon.
        ///   - styles: Visual styles for TryOn interface.
        ///   - strings: Text content for TryOn interface.
        ///   - toggles: Settings for enabling or disabling specific TryOn behaviors.
        public init(loadingPage: LoadingPage,
                    inputImageValidation: InputValidation,
                    cart: Cart?,
                    fitDisclaimer: FitDisclaimer?,
                    feedback: Feedback?,
                    generationsHistory: GenerationsHistory?,
                    otherPhoto: ContinueWithOtherPhoto,
                    icons: Icons,
                    styles: Styles,
                    strings: Strings,
                    toggles: Toggles) {
            self.loadingPage = loadingPage
            self.inputImageValidation = inputImageValidation
            self.cart = cart
            self.fitDisclaimer = fitDisclaimer
            self.feedback = feedback
            self.generationsHistory = generationsHistory
            self.otherPhoto = otherPhoto
            self.icons = icons
            self.styles = styles
            self.strings = strings
            self.toggles = toggles
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.TryOn {
    /// Icons for the TryOn interface.
    public struct Icons: Sendable {
        /// Icon displayed for the TryOn magic button (20x20).
        public let magic20: UIImage
        
        /// Creates custom icons.
        ///
        /// - Parameters:
        ///   - magic20: Icon displayed for the TryOn magic button (20x20).
        public init(magic20: UIImage) {
            self.magic20 = magic20
        }
    }
}

// MARK: - Styles

extension Aiuta.Configuration.Features.TryOn {
    /// Visual styles for the TryOn interface.
    public struct Styles: Sendable {
        /// Gradient style for the TryOn magic button.
        public let tryOnButtonGradient: [UIColor]
        
        /// Creates custom styles.
        ///
        /// - Parameters:
        ///   - tryOnButtonGradient: Gradient style for the TryOn magic button.
        public init(tryOnButtonGradient: [UIColor]) {
            self.tryOnButtonGradient = tryOnButtonGradient
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.TryOn {
    /// Text content for the TryOn interface.
    public struct Strings: Sendable {
        /// Title displayed on the TryOn page.
        public let tryOnPageTitle: String
        
        /// Label for the "Try On" button.
        public let tryOn: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - tryOnPageTitle: Title displayed on the TryOn page.
        ///   - tryOn: Label for the "Try On" button.
        public init(tryOnPageTitle: String,
                    tryOn: String) {
            self.tryOnPageTitle = tryOnPageTitle
            self.tryOn = tryOn
        }
    }
}

// MARK: - Toggles

extension Aiuta.Configuration.Features.TryOn {
    /// Settings for specific TryOn behaviors.
    public struct Toggles: Sendable {
        /// Whether the SDK should continue tracking the generation process in the background
        /// when the user closes the SDK.
        ///
        /// If disabled, the SDK will stop tracking the operation and halt all activity upon closing.
        /// Note that the Aiuta backend will still complete the operation even if the SDK stops tracking it.
        public let allowsBackgroundExecution: Bool
        
        /// While waiting for the try-on result, try to highlight the human outline using iOS system
        /// tools on the animation screen.
        ///
        /// Works locally. iOS 15+. In case of failure, the regular animation of the loader will not be affected.
        public let tryGeneratePersonSegmentation: Bool
        
        /// Creates custom settings.
        ///
        /// - Parameters:
        ///   - allowsBackgroundExecution: Whether the SDK should continue tracking the generation process in the background when the user closes the SDK.
        ///   - tryGeneratePersonSegmentation: While waiting for the try-on result, try to highlight the human outline using iOS system tools on the animation screen.
        public init(allowsBackgroundExecution: Bool,
                    tryGeneratePersonSegmentation: Bool) {
            self.allowsBackgroundExecution = allowsBackgroundExecution
            self.tryGeneratePersonSegmentation = tryGeneratePersonSegmentation
        }
    }
}
