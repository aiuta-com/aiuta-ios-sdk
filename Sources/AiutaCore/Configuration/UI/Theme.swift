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

extension Aiuta.Configuration.UserInterface {
    /// Visual theme configuration for the SDK.
    ///
    /// Controls the color scheme, branding, and styling of all UI components.
    public struct Theme: Sendable {
        /// Color palette for backgrounds, text, borders, and accent colors.
        public let color: ColorTheme
        
        /// Typography styles for text labels (titles, regular text, subtle text).
        public let label: LabelTheme
        
        /// Shapes and error icons for image views.
        public let image: ImageTheme
        
        /// Typography and shapes for buttons.
        public let button: ButtonTheme
        
        /// Navigation bar with page title, back/close buttons.
        public let pageBar: PageBarTheme
        
        /// Bottom sheet appearance with grabber and delimiters.
        public let bottomSheet: BottomSheetTheme
        
        /// Loading indicator icons, colors, and animation timing.
        public let activityIndicator: ActivityIndicatorTheme
        
        /// Snackbar shown when selecting multiple items (strings, icons, colors).
        public let selectionSnackbar: SelectionSnackbarTheme
        
        /// Snackbar shown for error messages with retry button.
        public let errorSnackbar: ErrorSnackbarTheme
        
        /// Product information bar with name, brand, and optional prices.
        public let productBar: ProductBarTheme
        
        /// "Powered By Aiuta" label styling.
        ///
        /// - Note: In accordance with your agreement with Aiuta, the `powerBar` may be hidden
        ///   based on the subscription details retrieved from the Aiuta backend. However, to
        ///   avoid adding cross complexity to the SDK, we kindly request that you configure its styles
        ///   here regardless of whether it will be displayed or not.
        ///
        /// - Note: If the SDK fails to load the subscription details from the Aiuta backend,
        ///   the "Powered By Aiuta" `powerBar` will *NOT* be displayed by default until the
        ///   subscription details are successfully loaded and the agreement explicitly allows
        ///   its display.
        public let powerBar: PowerBarTheme
        
        /// Creates a fully customizable theme.
        /// https://docs.aiuta.com/sdk/developer/configuration/ui/theme/
        ///
        /// - Parameters:
        ///   - color: Color palette for backgrounds, text, borders, and accent colors.
        ///   - label: Typography styles for text labels.
        ///   - image: Shapes and error icons for image views.
        ///   - button: Typography and shapes for buttons.
        ///   - pageBar: Navigation bar with page title, back/close buttons.
        ///   - bottomSheet: Bottom sheet appearance with grabber and delimiters.
        ///   - activityIndicator: Loading indicator icons, colors, and animation timing.
        ///   - selectionSnackbar: Snackbar shown when selecting multiple items.
        ///   - errorSnackbar: Snackbar shown for error messages with retry button.
        ///   - productBar: Product information bar with name, brand, and optional prices.
        ///   - powerBar: "Powered By Aiuta" label styling.
        public init(color: ColorTheme,
                    label: LabelTheme,
                    image: ImageTheme,
                    button: ButtonTheme,
                    pageBar: PageBarTheme,
                    bottomSheet: BottomSheetTheme,
                    activityIndicator: ActivityIndicatorTheme,
                    selectionSnackbar: SelectionSnackbarTheme,
                    errorSnackbar: ErrorSnackbarTheme,
                    productBar: ProductBarTheme,
                    powerBar: PowerBarTheme) {
            self.color = color
            self.label = label
            self.image = image
            self.button = button
            self.pageBar = pageBar
            self.bottomSheet = bottomSheet
            self.activityIndicator = activityIndicator
            self.selectionSnackbar = selectionSnackbar
            self.errorSnackbar = errorSnackbar
            self.productBar = productBar
            self.powerBar = powerBar
        }
    }
}
