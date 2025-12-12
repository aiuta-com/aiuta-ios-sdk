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
    /// Defines collections of colors used for various UI components in the SDK.
    /// These colors are essential for maintaining a consistent visual theme
    /// across the SDK's user interface.
    public enum Colors {
        /// Represents the minimum required set of colors that must be provided
        /// to ensure the SDK's UI components function correctly. This includes
        /// colors for general UI themes and required features.
        public typealias Required =
            UserInterface.ColorTheme.Provider &
            UserInterface.ErrorSnackbarTheme.Colors.Provider &
            UserInterface.SelectionSnackbarTheme.Colors.Provider

        /// Represents the complete set of colors that can be used across all
        /// features and UI components in the SDK. This includes the required
        /// colors and any additional colors for extended customization.
        public typealias Full = Required
    }
}
