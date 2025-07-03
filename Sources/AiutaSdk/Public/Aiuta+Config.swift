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

extension Aiuta {
    /// Represents the configuration options for the Aiuta SDK.
    ///
    /// The `Configuration` enum defines how the SDK behaves, including its appearance,
    /// interaction with the host application, and the set of features provided to the user.
    /// Developers can choose from predefined configurations or fully customize the SDK
    /// to meet their specific requirements.
    public enum Configuration {
        /// A demo configuration for quick testing of the SDK.
        ///
        /// This configuration is intended for initial testing to verify that the SDK
        /// is integrated correctly. It does not require an API key or subscription ID
        /// and will always fail the try-on feature with a "Something went wrong" error.
        /// Use this configuration only for development purposes before obtaining
        /// the necessary credentials.
        ///
        /// - Parameters:
        ///   - validation: Specifies the validation policy for the `Info.plist` file.
        ///     The default value is `.ignore`, which skips validation. Enabling validation
        ///     ensures that the `Info.plist` contains all required description keys for
        ///     the SDK to function properly.
        case demo(validation: ValidationPolicy = .ignore)

        /// A default configuration for development and testing.
        ///
        /// This configuration is optimized for debug builds and includes all recommended
        /// features and settings for development purposes. It performs validation checks
        /// on the `Info.plist` file and triggers a `fatalError()` if any required keys
        /// are missing. This ensures that issues are caught early during development.
        ///
        /// - Parameters:
        ///   - auth: Specifies the authentication method to be used by the SDK.
        case debug(auth: Aiuta.Auth)

        /// A default configuration for production use.
        ///
        /// This configuration is optimized for release builds and includes all recommended
        /// features and settings for production environments. It skips all validation checks
        /// to prioritize stability and performance. Use this configuration when deploying
        /// the application to end users.
        ///
        /// - Parameters:
        ///   - auth: Specifies the authentication method to be used by the SDK.
        case release(auth: Aiuta.Auth)

        /// A fully customizable configuration for the SDK.
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
