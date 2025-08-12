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

extension Aiuta {
    /// Represents the configuration options for the Aiuta SDK.
    /// https://docs.aiuta.com/sdk/ios/configuration/
    ///
    /// The `Configuration` enum defines how the SDK behaves, including its appearance,
    /// interaction with the host application, and the set of features provided to the user.
    ///
    /// - Note: See https://docs.aiuta.com/sdk/ios/quick-test/ for a quick testing SDK
    /// integration with test `apiKey` auth and sample product data.
    public enum Configuration {
        /// A default configuration for the SDK.
        ///
        /// This configuration includes all recommended features and settings for use.
        /// It requires an auth configuration, and supports a custom terms of service URL,
        /// color scheme, brand color, and validation policy to be set for debug and release
        /// builds. It is suitable for production use and provides a good balance
        /// between functionality and performance.
        ///
        /// - Parameters:
        ///   - auth: Specifies the authentication method to be used by the SDK.
        ///   - consent: Configures user consent options for data processing.
        ///   - theme: Configures the appearance and behavior of the SDK's user interface.
        ///   - analytics: Configures how analytics events are handled within the SDK.
        ///   - debugSettings: Configures the debug settings for the SDK.
        ///     The default value is `.release`, which applies production-ready settings.
        case `default`(auth: Aiuta.Auth,
                       consent: Features.Consent = .none,
                       theme: UserInterface.ColorTheme = .default,
                       analytics: Aiuta.Analytics = .none,
                       debugSettings: DebugSettings = .release)

        /// A fully customizable configuration for the SDK.
        /// https://docs.aiuta.com/sdk/developer/configuration/
        ///
        /// This configuration allows developers to customize every aspect of the SDK,
        /// including authentication, user interface, features, analytics, and debug settings.
        /// Use this option to tailor the SDK to specific application requirements.
        ///
        /// - Parameters:
        ///   - auth: Specifies the authentication method to be used by the SDK.
        ///   - userInterface: Configures the appearance and behavior of the SDK's user interface.
        ///     The default value is `.default`, which applies the standard UI settings.
        ///   - features: Configures the set of features enabled in the SDK.
        ///     The default value is `.default`, which enables all standard features.
        ///   - analytics: Configures how analytics events are handled within the SDK.
        ///     The default value is `.none`, which disables analytics tracking.
        ///   - debugSettings: Configures the debug settings for the SDK.
        ///     The default value is `.release`, which applies production-ready settings.
        case custom(auth: Aiuta.Auth,
                    userInterface: UserInterface = .default,
                    features: Features = .default,
                    analytics: Aiuta.Analytics = .none,
                    debugSettings: DebugSettings = .release)
    }
}
