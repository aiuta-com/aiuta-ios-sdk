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
    /// Additional feedback options configuration for the TryOn feature.
    public struct Other: Sendable {
        /// Text content for additional feedback options.
        public let strings: Strings
        
        /// Creates an additional feedback configuration.
        ///
        /// - Parameters:
        ///   - strings: Text content for additional feedback options.
        public init(strings: Strings) {
            self.strings = strings
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.TryOn.Feedback.Other {
    /// Text content for additional feedback options.
    public struct Strings: Sendable {
        /// Label for the "Other" feedback option.
        public let feedbackOptionOther: String
        
        /// Title displayed for the "Other" feedback.
        public let otherFeedbackTitle: String
        
        /// Label for the "Send" button.
        public let otherFeedbackButtonSend: String
        
        /// Label for the "Cancel" button.
        public let otherFeedbackButtonCancel: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - feedbackOptionOther: Label for the "Other" feedback option.
        ///   - otherFeedbackTitle: Title displayed for the "Other" feedback.
        ///   - otherFeedbackButtonSend: Label for the "Send" button.
        ///   - otherFeedbackButtonCancel: Label for the "Cancel" button.
        public init(feedbackOptionOther: String,
                    otherFeedbackTitle: String,
                    otherFeedbackButtonSend: String,
                    otherFeedbackButtonCancel: String) {
            self.feedbackOptionOther = feedbackOptionOther
            self.otherFeedbackTitle = otherFeedbackTitle
            self.otherFeedbackButtonSend = otherFeedbackButtonSend
            self.otherFeedbackButtonCancel = otherFeedbackButtonCancel
        }
    }
}
