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
    /// Defines a collection of shape configurations used throughout the SDK.
    /// These shapes are essential for maintaining a consistent visual style
    /// across various UI components, such as buttons, images, and sheets.
    public enum Shapes {
        /// Represents the minimum set of shapes required for the SDK to
        /// function correctly.
        public typealias Required =
            UserInterface.BottomSheetTheme.Shapes.Provider &
            UserInterface.ButtonTheme.Shapes.Provider &
            UserInterface.ImageTheme.Shapes.Provider

        /// Represents the complete set of shapes available for all features
        /// and UI components in the SDK. This includes the required shapes
        /// and any additional shapes for extended customization.
        public typealias Full = Required
    }
}
