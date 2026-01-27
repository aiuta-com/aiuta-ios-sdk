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

extension Aiuta.Configuration {
    /// Configures the features that can be enabled or disabled in the SDK.
    ///
    /// This configuration allows you to control which features are active in your app.
    /// You can use the default set of features or customize the configuration to suit
    /// your specific needs.
    public struct Features: Sendable {
        public let welcomeScreen: WelcomeScreen?
        public let onboarding: Onboarding?
        public let consent: Consent
        public let imagePicker: ImagePicker
        public let tryOn: TryOn
        public let share: Share?
        public let wishlist: Wishlist?
        public let sizeFit: SizeFit?

        public init(welcomeScreen: WelcomeScreen?,
                    onboarding: Onboarding?,
                    consent: Consent,
                    imagePicker: ImagePicker,
                    tryOn: TryOn,
                    share: Share?,
                    wishlist: Wishlist?,
                    sizeFit: SizeFit?) {
            self.welcomeScreen = welcomeScreen
            self.onboarding = onboarding
            self.consent = consent
            self.imagePicker = imagePicker
            self.tryOn = tryOn
            self.share = share
            self.wishlist = wishlist
            self.sizeFit = sizeFit
        }
    }
}

extension Aiuta.Configuration.Features {
    public static func `default`() -> Self {
        // TODO: Provide proper default values for required parameters
        fatalError("default() needs to be implemented with proper default values")
    }
}
