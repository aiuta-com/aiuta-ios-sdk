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

import AiutaConfig
import AiutaCore
import UIKit

// MARK: - UserInterface

extension Aiuta.Configuration.UserInterface {
    public static var `default`: Self {
        .init(
            theme: .default,
            presentationStyle: .pageSheet,
            swipeToDismissPolicy: .protectTheNecessaryPages
        )
    }
}

// MARK: - Theme

extension Aiuta.Configuration.UserInterface.Theme {
    public static var `default`: Self {
        .init(
            color: .default,
            label: .default,
            image: .default,
            button: .default,
            pageBar: .default,
            bottomSheet: .default,
            activityIndicator: .default,
            selectionSnackbar: .default,
            errorSnackbar: .default,
            productBar: .default,
            powerBar: .default
        )
    }
}

// MARK: - ColorTheme

extension Aiuta.Configuration.UserInterface.ColorTheme {
    public static var `default`: Self {
        .init(
            scheme: .light,
            brand: UIColor(red: 0, green: 0, blue: 0, alpha: 1),
            primary: UIColor(red: 0, green: 0, blue: 0, alpha: 1),
            secondary: UIColor(red: 0x9F / 255.0, green: 0x9F / 255.0, blue: 0x9F / 255.0, alpha: 1),
            onDark: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
            onLight: UIColor(red: 0, green: 0, blue: 0, alpha: 1),
            background: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
            screen: nil,
            neutral: UIColor(red: 0xF2 / 255.0, green: 0xF2 / 255.0, blue: 0xF7 / 255.0, alpha: 1),
            border: UIColor(red: 0xE5 / 255.0, green: 0xE5 / 255.0, blue: 0xEA / 255.0, alpha: 1),
            outline: UIColor(red: 0xC7 / 255.0, green: 0xC7 / 255.0, blue: 0xCC / 255.0, alpha: 1)
        )
    }
}

// MARK: - LabelTheme

extension Aiuta.Configuration.UserInterface.LabelTheme {
    public static var `default`: Self {
        .init(typography: .init(
            titleL: .init(size: 24, weight: .bold),
            titleM: .init(size: 20, weight: .semibold, kern: -0.4),
            regular: .init(size: 17, weight: .medium, kern: -0.51, lineHeightMultiple: 1.08),
            subtle: .init(size: 15, weight: .regular, kern: -0.15, lineHeightMultiple: 1.01)
        ))
    }
}

// MARK: - ImageTheme

extension Aiuta.Configuration.UserInterface.ImageTheme {
    public static var `default`: Self {
        .init(
            shapes: .init(
                imageL: .continuous(radius: 24),
                imageM: .continuous(radius: 16)
            ),
            icons: .init(
                imageError36: AiutaAssets.bundleImage("aiutaIcon36ImageError")!
            )
        )
    }
}

// MARK: - ButtonTheme

extension Aiuta.Configuration.UserInterface.ButtonTheme {
    public static var `default`: Self {
        .init(
            typography: .init(
                buttonM: .init(size: 17, weight: .semibold, kern: -0.17, lineHeightMultiple: 0.89),
                buttonS: .init(size: 13, weight: .semibold, kern: -0.13, lineHeightMultiple: 1.16)
            ),
            shapes: .init(
                buttonM: .continuous(radius: 8),
                buttonS: .continuous(radius: 8)
            )
        )
    }
}

// MARK: - PageBarTheme

extension Aiuta.Configuration.UserInterface.PageBarTheme {
    public static var `default`: Self {
        .init(
            typography: .init(
                pageTitle: .init(size: 17, weight: .medium, kern: -0.51, lineHeightMultiple: 1.08)
            ),
            icons: .init(
                back24: AiutaAssets.bundleImage("aiutaIcon24Back")!,
                close24: AiutaAssets.bundleImage("aiutaIcon24Close")!
            ),
            settings: .init(preferCloseButtonOnTheRight: false)
        )
    }
}

// MARK: - BottomSheetTheme

extension Aiuta.Configuration.UserInterface.BottomSheetTheme {
    public static var `default`: Self {
        .init(
            typography: .init(
                iconButton: .init(size: 17, weight: .medium, kern: -0.17)
            ),
            shapes: .init(
                bottomSheet: .continuous(radius: 16)
            ),
            grabber: .init(width: 36, height: 3, offset: 6),
            settings: .init(extendDelimitersToTheRight: false, extendDelimitersToTheLeft: false)
        )
    }
}

// MARK: - ActivityIndicatorTheme

extension Aiuta.Configuration.UserInterface.ActivityIndicatorTheme {
    public static var `default`: Self {
        .init(
            icons: .init(
                loading14: AiutaAssets.bundleImage("aiutaIcon14Loading") ?? UIImage()
            ),
            colors: .init(
                overlay: UIColor(red: 0, green: 0, blue: 0, alpha: 0x99 / 255.0)
            ),
            settings: .init(indicationDelay: 500, spinDuration: 1500)
        )
    }
}

// MARK: - SelectionSnackbarTheme

extension Aiuta.Configuration.UserInterface.SelectionSnackbarTheme {
    public static var `default`: Self {
        .init(
            strings: .init(
                select: "Select",
                cancel: "Cancel",
                selectAll: "Select all",
                unselectAll: "Unselect all"
            ),
            icons: .init(
                trash24: AiutaAssets.bundleImage("aiutaIcon24Trash")!,
                check20: AiutaAssets.bundleImage("aiutaIcon20Check")!
            ),
            colors: .init(
                selectionBackground: UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            )
        )
    }
}

// MARK: - ErrorSnackbarTheme

extension Aiuta.Configuration.UserInterface.ErrorSnackbarTheme {
    public static var `default`: Self {
        .init(
            strings: .init(
                defaultErrorMessage: "Something went wrong.\nPlease try again later",
                tryAgainButton: "Try again"
            ),
            icons: .init(
                error36: AiutaAssets.bundleImage("aiutaIcon36Error")!
            ),
            colors: .init(
                errorBackground: UIColor(red: 0xEF / 255.0, green: 0x57 / 255.0, blue: 0x54 / 255.0, alpha: 1),
                errorPrimary: UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            )
        )
    }
}

// MARK: - ProductBarTheme

extension Aiuta.Configuration.UserInterface.ProductBarTheme {
    public static var `default`: Self {
        .init(
            icons: .init(
                arrow16: AiutaAssets.bundleImage("aiutaIcon16Arrow")!
            ),
            typography: .init(
                product: .init(size: 13, weight: .regular),
                brand: .init(size: 12, weight: .medium, kern: -0.12)
            ),
            settings: .init(applyProductFirstImageExtraPadding: false),
            prices: .init(
                typography: .init(
                    price: .init(size: 14, weight: .bold, kern: -0.14)
                ),
                colors: .init(
                    discountedPrice: UIColor(red: 0xFB / 255.0, green: 0x10 / 255.0, blue: 0x10 / 255.0, alpha: 1)
                )
            )
        )
    }
}

// MARK: - PowerBarTheme

extension Aiuta.Configuration.UserInterface.PowerBarTheme {
    public static var `default`: Self {
        .init(
            strings: .init(poweredByAiuta: "Powered by Aiuta"),
            colors: .init(aiuta: .default)
        )
    }
}
