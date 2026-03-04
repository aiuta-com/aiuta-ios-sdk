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
import Foundation

public struct ShapesPack: Sendable {
    public let imageL: Aiuta.Shape
    public let imageM: Aiuta.Shape
    public let imageS: Aiuta.Shape
    public let buttonL: Aiuta.Shape
    public let buttonM: Aiuta.Shape
    public let buttonS: Aiuta.Shape
    public let bottomSheet: Aiuta.Shape
    public let onboardingImageL: Aiuta.Shape
    public let onboardingImageS: Aiuta.Shape
    public let feedbackButton: Aiuta.Shape

    public init(imageL: Aiuta.Shape = .continuous(radius: 24),
                imageM: Aiuta.Shape = .continuous(radius: 16),
                imageS: Aiuta.Shape = .continuous(radius: 8),
                buttonL: Aiuta.Shape = .continuous(radius: 16),
                buttonM: Aiuta.Shape = .continuous(radius: 8),
                buttonS: Aiuta.Shape = .continuous(radius: 8),
                bottomSheet: Aiuta.Shape = .continuous(radius: 16),
                onboardingImageL: Aiuta.Shape = .continuous(radius: 16),
                onboardingImageS: Aiuta.Shape = .continuous(radius: 16),
                feedbackButton: Aiuta.Shape = .capsule) {
        self.imageL = imageL
        self.imageM = imageM
        self.imageS = imageS
        self.buttonL = buttonL
        self.buttonM = buttonM
        self.buttonS = buttonS
        self.bottomSheet = bottomSheet
        self.onboardingImageL = onboardingImageL
        self.onboardingImageS = onboardingImageS
        self.feedbackButton = feedbackButton
    }
}
