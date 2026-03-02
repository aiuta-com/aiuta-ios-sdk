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
@_spi(Aiuta) import AiutaKit
import UIKit

extension Sdk.Configuration {
    struct Shapes {
        // MARK: - Image

        var imageL: Aiuta.Shape = .continuous(radius: 24)
        var imageM: Aiuta.Shape = .continuous(radius: 16)
        var imageS: Aiuta.Shape = .continuous(radius: 8)

        // MARK: - Button

        var buttonL: Aiuta.Shape = .continuous(radius: 16)
        var buttonM: Aiuta.Shape = .continuous(radius: 8)
        var buttonS: Aiuta.Shape = .continuous(radius: 8)

        // MARK: - BottomSheet

        var bottomSheet: Aiuta.Shape = .continuous(radius: 16)

        // MARK: - BottomSheet.Grabber

        var grabberWidth: CGFloat = 36
        var grabberHeight: CGFloat = 3
        var grabberOffset: CGFloat = 6

        // MARK: - Onboarding

        var onboardingImageL: Aiuta.Shape = .continuous(radius: 16)
        var onboardingImageS: Aiuta.Shape = .continuous(radius: 16)

        // MARK: - TryOn.Feedback

        var feedbackButton: Aiuta.Shape = .continuous(radius: .infinity)
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
            case .rectangular: return 0
        }
    }
}
