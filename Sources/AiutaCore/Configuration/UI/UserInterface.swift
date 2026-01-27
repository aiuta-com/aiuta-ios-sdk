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
    /// Represents the user interface (UI) configuration options for the Aiuta SDK.
    ///
    /// The `UserInterface` struct allows developers to customize the appearance and behavior
    /// of the SDK's user interface.
    public struct UserInterface: Sendable {
        /// Visual theme controlling colors, typography, and component styling.
        public let theme: Theme
        
        /// How the SDK is presented as a modal view controller.
        public let presentationStyle: PresentationStyle
        
        /// Behavior for dismissing the SDK using a top-down swipe gesture.
        public let swipeToDismissPolicy: SwipeToDismissPolicy
        
        /// Creates a custom UI configuration.
        /// https://docs.aiuta.com/sdk/developer/configuration/ui/
        ///
        /// - Parameters:
        ///   - theme: Visual theme controlling colors, typography, and component styling.
        ///   - presentationStyle: How the SDK is presented as a modal view controller.
        ///   - swipeToDismissPolicy: Behavior for dismissing the SDK using a top-down swipe gesture.
        public init(theme: Theme,
                    presentationStyle: PresentationStyle,
                    swipeToDismissPolicy: SwipeToDismissPolicy) {
            self.theme = theme
            self.presentationStyle = presentationStyle
            self.swipeToDismissPolicy = swipeToDismissPolicy
        }
    }
}
