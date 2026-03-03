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
import UIKit

public struct TypographyPack: Sendable {
    public let titleL: Aiuta.TextStyle
    public let titleM: Aiuta.TextStyle
    public let regular: Aiuta.TextStyle
    public let subtle: Aiuta.TextStyle
    public let buttonM: Aiuta.TextStyle
    public let buttonS: Aiuta.TextStyle
    public let pageTitle: Aiuta.TextStyle
    public let iconButton: Aiuta.TextStyle
    public let product: Aiuta.TextStyle
    public let brand: Aiuta.TextStyle
    public let price: Aiuta.TextStyle
    public let disclaimer: Aiuta.TextStyle

    public init(titleL: Aiuta.TextStyle = .init(size: 24, weight: .bold),
                titleM: Aiuta.TextStyle = .init(size: 20, weight: .semibold, kern: -0.4),
                regular: Aiuta.TextStyle = .init(size: 17, weight: .medium, kern: -0.51, lineHeightMultiple: 1.08),
                subtle: Aiuta.TextStyle = .init(size: 15, weight: .regular, kern: -0.15, lineHeightMultiple: 1.01),
                buttonM: Aiuta.TextStyle = .init(size: 17, weight: .semibold, kern: -0.17, lineHeightMultiple: 0.89),
                buttonS: Aiuta.TextStyle = .init(size: 13, weight: .semibold, kern: -0.13, lineHeightMultiple: 1.16),
                pageTitle: Aiuta.TextStyle = .init(size: 17, weight: .medium, kern: -0.51, lineHeightMultiple: 1.08),
                iconButton: Aiuta.TextStyle = .init(size: 17, weight: .medium, kern: -0.17),
                product: Aiuta.TextStyle = .init(size: 13, weight: .regular),
                brand: Aiuta.TextStyle = .init(size: 12, weight: .medium, kern: -0.12),
                price: Aiuta.TextStyle = .init(size: 14, weight: .bold, kern: -0.14),
                disclaimer: Aiuta.TextStyle = .init(size: 12, weight: .regular, kern: -0.12)) {
        self.titleL = titleL
        self.titleM = titleM
        self.regular = regular
        self.subtle = subtle
        self.buttonM = buttonM
        self.buttonS = buttonS
        self.pageTitle = pageTitle
        self.iconButton = iconButton
        self.product = product
        self.brand = brand
        self.price = price
        self.disclaimer = disclaimer
    }
}
