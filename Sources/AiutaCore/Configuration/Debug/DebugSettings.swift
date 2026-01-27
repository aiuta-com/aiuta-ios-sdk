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
    /// Represents the debug settings for the Aiuta SDK.
    ///
    /// Debug settings allow developers to configure how the SDK behaves during
    /// development and testing. These settings control logging and validation
    /// policies to ensure the SDK is properly configured and behaves as expected.
    public struct DebugSettings: Sendable {
        /// A Boolean value indicating whether the SDK should log debug information.
        /// When enabled, the SDK provides detailed logs to help developers understand its behavior.
        public let isLoggingEnabled: Bool
        
        /// A validation policy that checks whether the `info.plist` file contains all required
        /// descriptions for the enabled features. This ensures compliance with platform requirements.
        public let infoPlistDescriptionsPolicy: ValidationPolicy
        
        /// A validation policy that checks whether required strings in the SDK configuration
        /// are not empty. This prevents runtime issues caused by missing or invalid string values.
        public let emptyStringsPolicy: ValidationPolicy
        
        /// A validation policy that checks whether lists required by the SDK are of the correct size.
        /// This includes ensuring lists are not empty, not too large, or exactly the size required by the SDK.
        public let listSizePolicy: ValidationPolicy
        
        /// Fully customizable debug settings for the SDK.
        /// https://docs.aiuta.com/sdk/developer/configuration/debug-settings/
        ///
        /// - Parameters:
        ///   - isLoggingEnabled: A Boolean value indicating whether the SDK should log
        ///     debug information. When enabled, the SDK provides detailed logs to help
        ///     developers understand its behavior.
        ///   - infoPlistDescriptionsPolicy: A validation policy that checks whether the
        ///     `info.plist` file contains all required descriptions for the enabled features.
        ///     This ensures compliance with platform requirements.
        ///   - emptyStringsPolicy: A validation policy that checks whether required strings
        ///     in the SDK configuration are not empty. This prevents runtime issues caused
        ///     by missing or invalid string values.
        ///   - listSizePolicy: A validation policy that checks whether lists required by the
        ///     SDK are of the correct size. This includes ensuring lists are not empty, not
        ///     too large, or exactly the size required by the SDK.
        public init(isLoggingEnabled: Bool,
                    infoPlistDescriptionsPolicy: ValidationPolicy,
                    emptyStringsPolicy: ValidationPolicy,
                    listSizePolicy: ValidationPolicy) {
            self.isLoggingEnabled = isLoggingEnabled
            self.infoPlistDescriptionsPolicy = infoPlistDescriptionsPolicy
            self.emptyStringsPolicy = emptyStringsPolicy
            self.listSizePolicy = listSizePolicy
        }
        
        /// Convenient initializer for debug settings with a single validation policy for all checks.
        ///
        /// This initializer simplifies configuration by applying the same validation policy
        /// to all validation checks, including `infoPlistDescriptionsPolicy`, `emptyStringsPolicy`,
        /// and `listSizePolicy`.
        ///
        /// - Parameters:
        ///   - isLoggingEnabled: A Boolean value indicating whether the SDK should log
        ///     debug information. When enabled, the SDK provides detailed logs to help
        ///     developers understand its behavior.
        ///   - allValidationPolicies: A single validation policy applied to all validation
        ///     checks. This simplifies configuration by using the same policy for all checks.
        public init(isLoggingEnabled: Bool,
                    allValidationPolicies: ValidationPolicy) {
            self.isLoggingEnabled = isLoggingEnabled
            self.infoPlistDescriptionsPolicy = allValidationPolicies
            self.emptyStringsPolicy = allValidationPolicies
            self.listSizePolicy = allValidationPolicies
        }
        
        /// Default debug settings for development builds.
        ///
        /// - Logging is enabled to provide detailed information about the SDK's behavior.
        /// - All validation policies are set to `fatal`, meaning any validation errors
        ///   will cause the application to terminate immediately. This ensures that
        ///   invalid configurations are caught and fixed during development.
        public static let debug = DebugSettings(
            isLoggingEnabled: true,
            infoPlistDescriptionsPolicy: .fatal,
            emptyStringsPolicy: .fatal,
            listSizePolicy: .fatal
        )
        
        /// Default debug settings for production builds.
        ///
        /// - Logging is disabled to avoid exposing debug information in production.
        /// - All validation policies are set to `ignore`, meaning validation errors
        ///   will not interrupt the application's execution. This is suitable for
        ///   production environments where stability is prioritized.
        public static let release = DebugSettings(
            isLoggingEnabled: false,
            infoPlistDescriptionsPolicy: .ignore,
            emptyStringsPolicy: .ignore,
            listSizePolicy: .ignore
        )
    }
}
