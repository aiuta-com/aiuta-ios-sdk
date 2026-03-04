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

public struct ColorsPack: Sendable {
    // Theme
    public let brand: UIColor
    public let primary: UIColor
    public let secondary: UIColor
    public let onDark: UIColor
    public let onLight: UIColor
    public let background: UIColor
    public let neutral: UIColor
    public let border: UIColor
    // Component
    public let overlay: UIColor
    public let selectionBackground: UIColor
    public let errorBackground: UIColor
    public let errorPrimary: UIColor
    public let discountedPrice: UIColor
    // Loading
    public let loadingGradient: [UIColor]

    public init(brand: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1),
                primary: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1),
                secondary: UIColor = UIColor(red: 0x9F / 255.0, green: 0x9F / 255.0, blue: 0x9F / 255.0, alpha: 1),
                onDark: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1),
                onLight: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1),
                background: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1),
                neutral: UIColor = UIColor(red: 0xF2 / 255.0, green: 0xF2 / 255.0, blue: 0xF7 / 255.0, alpha: 1),
                border: UIColor = UIColor(red: 0xE5 / 255.0, green: 0xE5 / 255.0, blue: 0xEA / 255.0, alpha: 1),
                overlay: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0x99 / 255.0),
                selectionBackground: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1),
                errorBackground: UIColor = UIColor(red: 0xEF / 255.0, green: 0x57 / 255.0, blue: 0x54 / 255.0, alpha: 1),
                errorPrimary: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1),
                discountedPrice: UIColor = UIColor(red: 0xFB / 255.0, green: 0x10 / 255.0, blue: 0x10 / 255.0, alpha: 1),
                loadingGradient: [UIColor] = [
                    UIColor(red: 0x40 / 255.0, green: 0, blue: 1, alpha: 1),
                    UIColor(red: 0x40 / 255.0, green: 0, blue: 1, alpha: 0.5),
                    UIColor(red: 0x40 / 255.0, green: 0, blue: 1, alpha: 0),
                ]) {
        self.brand = brand
        self.primary = primary
        self.secondary = secondary
        self.onDark = onDark
        self.onLight = onLight
        self.background = background
        self.neutral = neutral
        self.border = border
        self.overlay = overlay
        self.selectionBackground = selectionBackground
        self.errorBackground = errorBackground
        self.errorPrimary = errorPrimary
        self.discountedPrice = discountedPrice
        self.loadingGradient = loadingGradient
    }
}
