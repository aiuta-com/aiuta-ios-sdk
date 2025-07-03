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
    /// Represents the validation policy for the SDK configuration.
    ///
    /// The validation policy determines how the SDK handles validation errors
    /// that occur during the configuration process. This allows developers to
    /// choose the appropriate behavior for their application when invalid
    /// configuration data is encountered.
    public enum ValidationPolicy {
        /// Ignores all validation errors.
        ///
        /// Use this option if you want the SDK to proceed without taking any
        /// action when validation errors occur. This is useful for scenarios
        /// where validation errors cannot be seen and should not harm the
        /// application's execution.
        ///
        /// Recommended for production builds.
        case ignore

        /// Logs validation errors to the console.
        ///
        /// This option is useful for debugging purposes, as it allows you to
        /// see validation errors in the console output without interrupting
        /// the application's execution.
        case warning

        /// Logs validation errors to a custom logger.
        ///
        /// Use this option if you want to handle validation errors in a custom
        /// way, such as sending them to an external logging service.
        /// You must provide a custom logger that conforms to the `Logger` protocol.
        ///
        /// - Parameter logger: A custom logger that handles validation error messages.
        case custom(Logger)

        /// Stops the application's execution with a `fatalError` when a validation error occurs.
        ///
        /// This option is useful for development and testing environments where
        /// validation errors must be addressed immediately. It ensures that
        /// invalid configurations are not used in the application.
        case fatal
    }
}

extension Aiuta.Configuration.ValidationPolicy {
    /// Protocol for custom loggers that handle validation errors.
    ///
    /// Implement this protocol to define a custom logger that processes
    /// validation error messages. This is required when using the `.custom`
    /// validation policy.
    public protocol Logger {
        /// Called when a validation error occurs.
        ///
        /// Use this method to handle validation error messages, such as logging
        /// them to a file, sending them to an external service, or displaying
        /// them in the user interface.
        ///
        /// - Parameter message: The error message describing the validation issue.
        func onValidationError(_ message: String)
    }
}
