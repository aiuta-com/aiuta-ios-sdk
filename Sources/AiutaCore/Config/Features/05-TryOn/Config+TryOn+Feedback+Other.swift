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

extension Aiuta.Configuration.Features.TryOn.Feedback {
    /// Configures additional feedback options for the TryOn feature. You can
    /// use the default settings, disable additional options, or customize the
    /// behavior and text content for these options.
    public enum Other {
        /// Use the default configuration for additional feedback options.
        case `default`

        /// Disable additional feedback options.
        case none

        /// Use a custom configuration for additional feedback options.
        ///
        /// - Parameters:
        ///   - strings: Custom text content for additional feedback options.
        case custom(strings: Strings)
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.TryOn.Feedback.Other {
    /// Defines the text content used for additional feedback options. You can
    /// use the default text, provide custom strings, or implement a custom
    /// provider to manage the text content.
    public enum Strings {
        /// Use the default text content for additional feedback options.
        case `default`

        /// Specify custom text content for additional feedback options.
        ///
        /// - Parameters:
        ///   - feedbackOptionOther: The label for the "Other" feedback option.
        ///   - otherFeedbackTitle: The title displayed for the "Other" feedback.
        ///   - otherFeedbackButtonSend: The label for the "Send" button.
        ///   - otherFeedbackButtonCancel: The label for the "Cancel" button.
        case custom(feedbackOptionOther: String,
                    otherFeedbackTitle: String,
                    otherFeedbackButtonSend: String,
                    otherFeedbackButtonCancel: String)

        /// Use a custom implementation to manage the text content for additional
        /// feedback options.
        ///
        /// - Parameters:
        ///   - provider: An object that conforms to the `Provider` protocol.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.TryOn.Feedback.Other.Strings {
    /// A protocol for managing the text content of additional feedback options.
    /// Implement this protocol to define the labels and titles for the "Other"
    /// feedback option.
    public protocol Provider {
        /// The label for the "Other" feedback option.
        var feedbackOptionOther: String { get }

        /// The title displayed for the "Other" feedback.
        var otherFeedbackTitle: String { get }

        /// The label for the "Send" button.
        var otherFeedbackButtonSend: String { get }

        /// The label for the "Cancel" button.
        var otherFeedbackButtonCancel: String { get }
    }
}
