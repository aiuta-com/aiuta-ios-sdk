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
    /// Defines collections of icons used for buttons and other UI components
    /// in the SDK. These icons are essential for maintaining a consistent
    /// visual style across the user interface.
    public enum Icons {
        /// Represents the minimum set of icons required to ensure the SDK's
        /// UI components function correctly. This includes icons for general
        /// themes and required features.
        public typealias Required =
            UserInterface.ImageTheme.Icons.Provider &
            UserInterface.ErrorSnackbarTheme.Icons.Provider &
            UserInterface.PageBarTheme.Icons.Provider &
            UserInterface.SelectionSnackbarTheme.Icons.Provider

        /// Represents the complete set of icons that can be used across all
        /// features and UI components in the SDK. This includes the required
        /// icons and any additional icons for extended features.
        public typealias Full = Required &
            Aiuta.Configuration.Features.WelcomeScreen.Icons.Provider
    }
}
