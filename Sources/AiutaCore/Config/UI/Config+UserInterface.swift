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
    /// The `UserInterface` enum allows developers to customize the appearance and behavior
    /// of the SDK's user interface. It provides a default configuration for standard use cases
    /// and a customizable option for more specific requirements.
    public enum UserInterface {
        /// The default UI configuration for the Aiuta SDK.
        ///
        /// This configuration applies a light theme, uses the `pageSheet` presentation style,
        /// and enforces the `protectTheNecessaryPages` swipe-to-dismiss policy. It is suitable
        /// for most applications that do not require extensive customization of the SDK's UI.
        case `default`

        /// A customizable UI configuration for the Aiuta SDK.
        /// https://docs.aiuta.com/sdk/developer/configuration/ui/
        ///
        /// This option allows developers to specify the visual theme, presentation style,
        /// and swipe-to-dismiss policy for the SDK. It provides flexibility to adapt the
        /// SDK's UI to match the application's design and user experience requirements.
        ///
        /// - Parameters:
        ///   - theme: The visual theme of the SDK. The default value applies a light color scheme.
        ///   - presentationStyle: Defines how the SDK is presented as a modal view controller.
        ///     The default value is `.pageSheet`, which displays the SDK in a sheet-style modal.
        ///   - swipeToDismissPolicy: Specifies the behavior for dismissing the SDK using a
        ///     top-down swipe gesture. The default value is `.protectTheNecessaryPages`, which
        ///     restricts swipe-to-dismiss functionality on critical pages to prevent accidental exits.
        case custom(theme: Theme = .default,
                    presentationStyle: PresentationStyle = .pageSheet,
                    swipeToDismissPolicy: SwipeToDismissPolicy = .protectTheNecessaryPages)
    }
}
