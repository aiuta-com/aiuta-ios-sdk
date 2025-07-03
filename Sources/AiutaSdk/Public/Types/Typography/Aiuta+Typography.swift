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
    /// Typography is a collection of text styles that you can use throughout
    /// the SDK. These styles help maintain a consistent appearance for text
    /// elements, such as titles, subtitles, buttons, and regular text.
    public enum Typography {
        /// Represents the minimum set of text styles required for the SDK to
        /// function properly. This includes styles for essential UI components
        /// like bottom sheets, buttons, labels, page bars, and product bars.
        public typealias Required =
            UserInterface.BottomSheetTheme.Typography.Provider &
            UserInterface.ButtonTheme.Typography.Provider &
            UserInterface.LabelTheme.Typography.Provider &
            UserInterface.PageBarTheme.Typography.Provider &
            UserInterface.ProductBarTheme.Typography.Provider

        /// Represents the complete set of text styles available for all
        /// features in the SDK. This includes the required styles and any
        /// additional styles used in extended features.
        public typealias Full = Required &
            Aiuta.Configuration.Features.WelcomeScreen.Typography.Provider
    }
}
