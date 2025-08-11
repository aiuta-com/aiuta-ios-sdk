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
    /// Defines the theme configuration options for the Aiuta SDK.
    ///
    /// The `Theme` enum allows developers to customize the visual appearance of the SDK.
    /// It provides predefined themes for standard use cases and a fully customizable option
    /// for advanced requirements. Themes control the color scheme, branding, and styling
    /// of various UI components within the SDK.
    public enum Theme {
        /// Applies the default Aiuta theme.
        ///
        /// This theme uses a predefined light or dark color scheme designed to align with
        /// the Aiuta SDK's standard visual identity. It is suitable for applications that
        /// do not require custom branding or extensive UI customization.
        ///
        /// - Parameters:
        ///   - scheme: Specifies whether the theme should use a light or dark color scheme.
        ///             https://docs.aiuta.com/sdk/developer/configuration/ui/theme/color/
        case aiuta(scheme: ColorScheme)

        /// Applies the default Aiuta theme with a custom brand color.
        /// https://docs.aiuta.com/sdk/developer/configuration/ui/theme/color/
        ///
        /// This theme builds on the default Aiuta theme but allows developers to specify
        /// a custom brand color. The brand color is used for primary action buttons and
        /// other key highlights, enabling the SDK to better align with the application's
        /// visual identity.
        ///
        /// - Parameters:
        ///   - scheme: Specifies whether the theme should use a light or dark color scheme.
        ///   - brand: The main accent color of the application, used for primary actions
        ///            and highlights throughout the SDK.
        case brand(scheme: ColorScheme,
                   brand: UIColor)

        /// Applies a fully customizable theme.
        /// https://docs.aiuta.com/sdk/developer/configuration/ui/theme/
        ///
        /// This option allows developers to define every aspect of the SDK's visual appearance,
        /// including colors, labels, images, buttons, and various UI components. It provides
        /// maximum flexibility for tailoring the SDK to match the application's design system.
        ///
        /// - Parameters:
        ///   - color: Configures the color palette for the SDK, including background and accent colors.
        ///   - label: Configures the appearance of text labels.
        ///   - image: Configures the styling of images used within the SDK.
        ///   - button: Configures the appearance of buttons, including their colors and styles.
        ///   - pageBar: Configures the appearance of the page navigation bar.
        ///   - bottomSheet: Configures the styling of the bottom sheet component.
        ///   - selectionSnackbar: Configures the appearance of the snackbar shown for selection actions.
        ///   - errorSnackbar: Configures the appearance of the snackbar shown for error messages.
        ///   - productBar: Configures the appearance of the product bar, which displays product-related information.
        ///   - powerBar: Configures the appearance of the "Powered By Aiuta" label.
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
        case custom(color: ColorTheme = .aiuta(scheme: .light),
                    label: LabelTheme = .default,
                    image: ImageTheme = .default,
                    button: ButtonTheme = .default,
                    pageBar: PageBarTheme = .default,
                    bottomSheet: BottomSheetTheme = .default,
                    activityIndicator: ActivityIndicatorTheme = .default,
                    selectionSnackbar: SelectionSnackbarTheme = .default,
                    errorSnackbar: ErrorSnackbarTheme = .default,
                    productBar: ProductBarTheme = .default,
                    powerBar: PowerBarTheme = .default)
    }
}
