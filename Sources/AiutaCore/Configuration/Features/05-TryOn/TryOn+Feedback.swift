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

extension Aiuta.Configuration.Features.TryOn {
    /// Feedback functionality configuration for the TryOn feature.
    public struct Feedback: Sendable {
        /// Optional additional feedback feature.
        public let other: Other?
        
        /// Text content for feedback-related actions.
        public let strings: Strings
        
        /// Icons for feedback-related actions.
        public let icons: Icons
        
        /// Shapes for feedback-related actions.
        public let shapes: Shapes
        
        /// Creates a feedback configuration.
        ///
        /// - Parameters:
        ///   - other: Optional additional feedback feature.
        ///   - strings: Text content for feedback-related actions.
        ///   - icons: Icons for feedback-related actions.
        ///   - shapes: Shapes for feedback-related actions.
        public init(other: Other?,
                    strings: Strings,
                    icons: Icons,
                    shapes: Shapes) {
            self.other = other
            self.strings = strings
            self.icons = icons
            self.shapes = shapes
        }
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.TryOn.Feedback {
    /// Text content for feedback functionality.
    public struct Strings: Sendable {
        /// Title displayed in the feedback section.
        public let feedbackTitle: String
        
        /// List of feedback options available to users.
        public let feedbackOptions: [String]
        
        /// Label for the "Skip" button.
        public let feedbackButtonSkip: String
        
        /// Label for the "Send" button.
        public let feedbackButtonSend: String
        
        /// Text displayed after feedback is sent.
        public let feedbackGratitudeText: String
        
        /// Creates custom text content.
        ///
        /// - Parameters:
        ///   - feedbackTitle: Title displayed in the feedback section.
        ///   - feedbackOptions: List of feedback options available to users.
        ///   - feedbackButtonSkip: Label for the "Skip" button.
        ///   - feedbackButtonSend: Label for the "Send" button.
        ///   - feedbackGratitudeText: Text displayed after feedback is sent.
        public init(feedbackTitle: String,
                    feedbackOptions: [String],
                    feedbackButtonSkip: String,
                    feedbackButtonSend: String,
                    feedbackGratitudeText: String) {
            self.feedbackTitle = feedbackTitle
            self.feedbackOptions = feedbackOptions
            self.feedbackButtonSkip = feedbackButtonSkip
            self.feedbackButtonSend = feedbackButtonSend
            self.feedbackGratitudeText = feedbackGratitudeText
        }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.TryOn.Feedback {
    /// Icons for feedback functionality.
    public struct Icons: Sendable {
        /// Icon for the "Like" feedback option.
        public let like36: UIImage
        
        /// Icon for the "Dislike" feedback option.
        public let dislike36: UIImage
        
        /// Icon displayed after feedback is sent.
        public let gratitude40: UIImage
        
        /// Creates custom icons.
        ///
        /// - Parameters:
        ///   - like36: Icon for the "Like" feedback option.
        ///   - dislike36: Icon for the "Dislike" feedback option.
        ///   - gratitude40: Icon displayed after feedback is sent.
        public init(like36: UIImage,
                    dislike36: UIImage,
                    gratitude40: UIImage) {
            self.like36 = like36
            self.dislike36 = dislike36
            self.gratitude40 = gratitude40
        }
    }
}

// MARK: - Shapes

extension Aiuta.Configuration.Features.TryOn.Feedback {
    /// Shapes for feedback functionality.
    public struct Shapes: Sendable {
        /// Shape for the feedback button.
        public let feedbackButton: Aiuta.Configuration.Shape
        
        /// Creates custom shapes.
        ///
        /// - Parameters:
        ///   - feedbackButton: Shape for the feedback button.
        public init(feedbackButton: Aiuta.Configuration.Shape) {
            self.feedbackButton = feedbackButton
        }
    }
}
