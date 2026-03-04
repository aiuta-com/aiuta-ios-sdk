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

import AiutaCore

public struct ColorsPack: Sendable {
    // Theme
    public let brand: Aiuta.Color
    public let primary: Aiuta.Color
    public let secondary: Aiuta.Color
    public let onDark: Aiuta.Color
    public let onLight: Aiuta.Color
    public let background: Aiuta.Color
    public let neutral: Aiuta.Color
    public let border: Aiuta.Color
    // Component
    public let overlay: Aiuta.Color
    public let selectionBackground: Aiuta.Color
    public let errorBackground: Aiuta.Color
    public let errorPrimary: Aiuta.Color
    public let discountedPrice: Aiuta.Color
    // Loading
    public let loadingGradient: [Aiuta.Color]

    public init(brand: Aiuta.Color = "#FF000000",
                primary: Aiuta.Color = "#FF000000",
                secondary: Aiuta.Color = "#FF9F9F9F",
                onDark: Aiuta.Color = "#FFFFFFFF",
                onLight: Aiuta.Color = "#FF000000",
                background: Aiuta.Color = "#FFFFFFFF",
                neutral: Aiuta.Color = "#FFF2F2F7",
                border: Aiuta.Color = "#FFE5E5EA",
                overlay: Aiuta.Color = "#99000000",
                selectionBackground: Aiuta.Color = "#FF000000",
                errorBackground: Aiuta.Color = "#FFEF5754",
                errorPrimary: Aiuta.Color = "#FFFFFFFF",
                discountedPrice: Aiuta.Color = "#FFFB1010",
                loadingGradient: [Aiuta.Color] = [
                    "#FF4000FF",
                    "#804000FF",
                    "#004000FF",
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
