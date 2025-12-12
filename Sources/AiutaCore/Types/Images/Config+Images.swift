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

extension Aiuta.Configuration {
    /// Defines collections of images used throughout the SDK. These images
    /// are essential for ensuring a consistent visual experience across
    /// various features and UI components.
    public enum Images {
        /// Represents the minimum set of images required for the SDK to
        /// function properly. This includes images necessary for general
        /// themes and required features.
        public typealias Required =
            UserInterface.ImageTheme.Icons.Provider

        /// Represents the complete set of images that can be used across
        /// all features and UI components in the SDK. This includes the
        /// required images and any additional images for all features.
        public typealias Full = Required &
            Aiuta.Configuration.Features.WelcomeScreen.Images.Provider
    }
}
