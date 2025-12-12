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
    /// A collection of string resources used throughout the SDK. These strings
    /// are essential for providing consistent text across various UI components
    /// and features, ensuring a cohesive user experience.
    public enum Strings {
        /// Represents the minimum set of strings required for the SDK to operate
        /// correctly. This includes strings for essential UI components.
        public typealias Required =
            UserInterface.ErrorSnackbarTheme.Strings.Provider &
            UserInterface.SelectionSnackbarTheme.Strings.Provider

        /// Represents the complete set of strings available for all features
        /// and UI components in the SDK. This includes the required strings
        /// and additional strings for extended features.
        public typealias Full = Required &
            Aiuta.Configuration.Features.WelcomeScreen.Strings.Provider
    }
}
