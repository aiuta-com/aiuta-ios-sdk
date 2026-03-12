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

#if SWIFT_PACKAGE
import AiutaConfig
import AiutaCore
@_spi(Aiuta) import AiutaKit
#endif
import UIKit

extension Sdk.Theme {
    struct Shapes {
        let config: Aiuta.Configuration
        private var theme: Aiuta.Configuration.UserInterface.Theme { config.userInterface.theme }

        // MARK: - Image

        var imageL: Aiuta.Shape { theme.image.shapes.imageL }
        var imageM: Aiuta.Shape { theme.image.shapes.imageM }
        var imageS: Aiuta.Shape { theme.image.shapes.imageS }

        // MARK: - Button

        var buttonL: Aiuta.Shape { theme.button.shapes.buttonL }
        var buttonM: Aiuta.Shape { theme.button.shapes.buttonM }
        var buttonS: Aiuta.Shape { theme.button.shapes.buttonS }

        // MARK: - BottomSheet

        var bottomSheet: Aiuta.Shape { theme.bottomSheet.shapes.bottomSheet }

        // MARK: - BottomSheet.Grabber

        var grabberWidth: CGFloat { theme.bottomSheet.grabber.width }
        var grabberHeight: CGFloat { theme.bottomSheet.grabber.height }
        var grabberOffset: CGFloat { theme.bottomSheet.grabber.offset }

        // MARK: - Onboarding

        var onboardingImageL: Aiuta.Shape { config.features.onboarding?.shapes.onboardingImageL ?? imageL }
        var onboardingImageS: Aiuta.Shape { config.features.onboarding?.shapes.onboardingImageS ?? imageS }

        // MARK: - BottomSheet.ChipsButton

        var chipsButton: Aiuta.Shape { theme.bottomSheet.shapes.chipsButton }
    }
}

// MARK: - Kit Layout shape support

extension LayoutMaker {
    var shape: Aiuta.Shape {
        get { .rectangular }
        set {
            switch newValue {
                case let .continuous(radius):
                    self.radius = radius
                    continuousCurve = true
                case let .circular(radius):
                    self.radius = radius
                    continuousCurve = false
                case .capsule:
                    self.radius = .infinity
                    continuousCurve = true
                case .rectangular:
                    radius = 0
            }
        }
    }
}

extension Aiuta.Shape {
    var radius: CGFloat {
        switch self {
            case let .continuous(radius): return radius
            case let .circular(radius): return radius
            case .capsule: return .infinity
            case .rectangular: return 0
        }
    }
}
