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

extension Aiuta.Configuration.UserInterface {
    /// Defines the behavior for dismissing the SDK using a top-down swipe gesture.
    /// https://docs.aiuta.com/sdk/developer/configuration/ui/#swipetodismisspolicy
    ///
    /// The `SwipeToDismissPolicy` enum provides options for controlling how users can
    /// dismiss the SDK by swiping down. This allows to balance user convenience with
    /// the need to protect critical pages or workflows from accidental dismissal.
    public enum SwipeToDismissPolicy: String, Equatable, Codable, CaseIterable, Sendable {
        /// Allows the SDK to be dismissed at any time by swiping down anywhere on the screen.
        ///
        /// This policy provides the most flexibility for users, enabling them to close the SDK
        /// from any page or context.
        case allowAlways

        /// Restricts dismissal to swiping down on the header area only.
        ///
        /// This policy limits the swipe-to-dismiss gesture to the header area, reducing the
        /// likelihood of accidental dismissals.
        case allowHeaderSwipeOnly

        /// Applies different swipe-to-dismiss policies based on the page context.
        ///
        /// - On pages that are safe to close, such as onboarding or photo picker pages, the
        ///   `allowAlways` policy is applied, allowing dismissal from anywhere on the screen.
        /// - On critical pages, such as those waiting for generation or displaying results,
        ///   the `allowHeaderSwipeOnly` policy is applied to prevent accidental dismissals.
        ///
        /// This policy provides a balance between user convenience and protecting critical
        /// workflows, ensuring that users can dismiss the SDK when appropriate while
        /// safeguarding important pages.
        case protectTheNecessaryPages
    }
}
