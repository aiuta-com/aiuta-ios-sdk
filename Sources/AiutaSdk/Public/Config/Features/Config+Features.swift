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
    public enum Features {
        /// Enables the features recommended for the default configuration.
        case `default`

        /// Allows you to define a custom set of features.
        ///
        /// - Parameters:
        ///   - welcomeScreen: Configures an optional welcome or splash screen.
        ///   - onboarding: Configures the onboarding process to guide users through
        ///                 the SDK's functionality.
        ///   - consent: Configures user consent options for data processing. This can
        ///              be integrated with onboarding or used as a standalone feature.
        ///   - imagePicker: Configures the image picker, which allows users to pick
        ///                  images from the photo library, take new photos, use predefined models,
        ///                  or reuse previous images.
        ///   - tryOn: Configures the virtual try-on feature.
        ///   - share: Configures the sharing feature, enabling users to share
        ///            generated images.
        ///   - wishlist: Configures the wishlist feature, allowing interaction with
        ///               the host app's wishlist.
        case custom(welcomeScreen: WelcomeScreen = .none,
                    onboarding: Onboarding = .default,
                    consent: Consent,
                    imagePicker: ImagePicker = .default,
                    tryOn: TryOn = .default,
                    share: Share = .default,
                    wishlist: Wishlist = .none)
    }
}
