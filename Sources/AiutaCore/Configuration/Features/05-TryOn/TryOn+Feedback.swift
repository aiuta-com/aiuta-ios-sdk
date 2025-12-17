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
    /// Configures the feedback functionality for the TryOn feature. You can use
    /// the default settings or customize the text, icons, and other related
    /// options to tailor the feedback experience.
    public enum Feedback {
        /// Use the default feedback configuration.
        case `default`

        /// Disable the feedback functionality.
        case none

        /// Use a custom feedback configuration with specific strings, icons,
        /// and other settings.
        ///
        /// - Parameters:
        ///   - other: Optional feedback feature to allow the user to provide
        ///            custom feedback on the try-on result.
        ///   - strings: Custom text content for feedback-related actions.
        ///   - icons: Custom icons for feedback-related actions.
        ///   - shapes: Custom shapes for feedback-related actions.
        case custom(other: Other,
                    strings: Strings,
                    icons: Icons,
                    shapes: Shapes)
    }
}

// MARK: - Strings

extension Aiuta.Configuration.Features.TryOn.Feedback {
    /// Defines the text content used in the feedback functionality. You can use
    /// the default text, provide custom strings, or implement a provider to
    /// manage the text content.
    public enum Strings {
        /// Use the default text content for feedback functionality.
        case `default`

        /// Specify custom text content for feedback functionality.
        ///
        /// - Parameters:
        ///   - feedbackTitle: The title displayed in the feedback section.
        ///   - feedbackOptions: The list of feedback options available to users.
        ///   - feedbackButtonSkip: The label for the "Skip" button.
        ///   - feedbackButtonSend: The label for the "Send" button.
        ///   - feedbackGratitudeText: The text displayed after feedback is sent.
        case custom(feedbackTitle: String,
                    feedbackOptions: [String],
                    feedbackButtonSkip: String,
                    feedbackButtonSend: String,
                    feedbackGratitudeText: String)

        /// Use a provider to manage the text content for feedback functionality.
        ///
        /// - Parameters:
        ///   - provider: An object that implements the `Provider` protocol.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.TryOn.Feedback.Strings {
    /// A protocol for managing the text content of the feedback functionality.
    /// Implement this protocol to define the title, options, button labels, and
    /// gratitude text.
    public protocol Provider {
        /// The title displayed in the feedback section.
        var feedbackTitle: String { get }

        /// The list of feedback options available to users.
        var feedbackOptions: [String] { get }

        /// The label for the "Skip" button.
        var feedbackButtonSkip: String { get }

        /// The label for the "Send" button.
        var feedbackButtonSend: String { get }

        /// The text displayed after feedback is sent.
        var feedbackGratitudeText: String { get }
    }
}

// MARK: - Icons

extension Aiuta.Configuration.Features.TryOn.Feedback {
    /// Defines the icons used in the feedback functionality. You can use the
    /// default icons, provide custom ones, or implement a provider to manage
    /// the icons.
    public enum Icons {
        /// Use the default icons for feedback functionality.
        case `default`

        /// Specify custom icons for feedback functionality.
        ///
        /// - Parameters:
        ///   - like36: The icon for the "Like" feedback option.
        ///   - dislike36: The icon for the "Dislike" feedback option.
        ///   - gratitude40: The icon displayed after feedback is sent.
        case custom(like36: UIImage,
                    dislike36: UIImage,
                    gratitude40: UIImage)

        /// Use a provider to manage the icons for feedback functionality.
        ///
        /// - Parameters:
        ///   - provider: An object that implements the `Provider` protocol.
        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.TryOn.Feedback.Icons {
    /// A protocol for managing the icons used in the feedback feature.
    /// Implement this protocol to define the icons for feedback options and
    /// gratitude display.
    public protocol Provider {
        /// The icon for the "Like" feedback option.
        var like36: UIImage { get }

        /// The icon for the "Dislike" feedback option.
        var dislike36: UIImage { get }

        /// The icon displayed after feedback is sent.
        var gratitude40: UIImage { get }
    }
}

// MARK: - Shapes

extension Aiuta.Configuration.Features.TryOn.Feedback {
    public enum Shapes {
        case `default`
        
        case inherited

        case custom(feedbackButton: Aiuta.Configuration.Shape)

        case provider(Provider)
    }
}

extension Aiuta.Configuration.Features.TryOn.Feedback.Shapes {
    public protocol Provider {
        var feedbackButton: Aiuta.Configuration.Shape { get }
    }
}
