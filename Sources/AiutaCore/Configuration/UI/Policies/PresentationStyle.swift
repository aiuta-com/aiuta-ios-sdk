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
    /// Specifies the modal presentation style for the Aiuta SDK.
    /// https://docs.aiuta.com/sdk/developer/configuration/ui/#presentationstyle
    ///
    /// The `PresentationStyle` enum defines how the SDK is displayed when presented as a modal view controller.
    /// It provides options for different presentation styles, allowing developers to choose the one that best
    /// fits their application's design and user experience.
    public enum PresentationStyle: String, Equatable, Codable, CaseIterable, Sendable {
        /// Presents the SDK in a page sheet style.
        ///
        /// This style is recommended for iOS 13 and later, as it introduces a modern modal presentation
        /// that allows part of the parent view to remain visible. This helps users retain context while
        /// interacting with the SDK.
        ///
        /// For more details, refer to [Apple's Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/sheets#Best-practices).
        case pageSheet

        /// Presents the SDK in a bottom sheet style.
        ///
        /// This is similar to a `pageSheet` but the parent view will not be "stacked"
        /// behind the sheet and remains fullscreen but covered by the sheet.
        ///
        /// This style is supported on iOS 16 and later, on devices running older iOS versions, this style
        /// will fall back to the `pageSheet` style.
        case bottomSheet

        /// Presents the SDK in full-screen mode.
        ///
        /// This style occupies the entire screen, hiding the parent view completely.
        case fullScreen
    }
}
