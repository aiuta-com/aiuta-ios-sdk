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
@_spi(Aiuta) import AiutaKit
import UIKit

final class SizeResultsUI: Scroll {
    let navBar = NavBar { it, _ in
        it.style = .actionTitleClose
    }

    let title = Label { it, ds in
        it.font = ds.fonts.titleM
        it.color = ds.colors.primary
        it.text = "Recommended size"
    }

    let recommendedSize = Label { it, ds in
        it.font = ds.fonts.sizeRecommendation
        it.color = ds.colors.primary
    }

    let bestSize = SizeResult()
    let nextSize = SizeResult { it, _ in
        it.grayscale()
    }

    let noResultIcon = Image { it, ds in
        it.isAutoSize = false
        it.source = ds.icons.error36
        it.tint = ds.colors.primary
        it.view.isVisible = false
    }

    let noResultDescription = Label { it, ds in
        it.font = ds.fonts.regular
        it.color = ds.colors.primary
        it.isMultiline = true
        it.alignment = .center
        it.text = "Sorry!\nThis item is designed for a different body type or gender. We can’t recommend a size"
        it.view.isVisible = false
    }

    let surveyTitle = Label { it, ds in
        it.font = ds.fonts.subtle
        it.color = ds.colors.primary
        it.text = "Parameters"
    }

    let surveyDescription = Label { it, ds in
        it.font = ds.fonts.subtle
        it.color = ds.colors.primary
    }

    let changeButton = LabelButton { it, ds in
        it.font = ds.fonts.buttonM
        it.color = .clear
        it.label.color = ds.colors.secondary
        it.text = "Change"
    }

    let acknowledge = LabelButton { it, ds in
        it.font = ds.fonts.buttonM
        it.color = ds.colors.brand
        it.label.color = ds.colors.onDark
        it.label.minScale = 0.5
        it.text = "Got it"
    }

    override func updateLayout() {
        title.layout.make { make in
            make.centerX = 0
            make.top = navBar.layout.bottomPin + 16
        }

        recommendedSize.layout.make { make in
            make.centerX = 0
            make.top = title.layout.bottomPin + 24
        }

        bestSize.layout.make { make in
            make.top = recommendedSize.layout.bottomPin + 40
        }

        nextSize.layout.make { make in
            make.top = bestSize.layout.bottomPin
        }

        acknowledge.layout.make { make in
            make.height = 50
            make.leftRight = 16
            make.bottom = layout.safe.insets.bottom + 16
            make.shape = ds.shapes.buttonM
        }

        changeButton.layout.make { make in
            make.height = 50
            make.leftRight = 16
            make.bottom = acknowledge.layout.topPin + 32
        }

        surveyDescription.layout.make { make in
            make.centerX = 0
            make.bottom = changeButton.layout.topPin
        }

        surveyTitle.layout.make { make in
            make.centerX = 0
            make.bottom = surveyDescription.layout.topPin + 8
        }

        nextSize.view.isMaxOpaque = surveyTitle.layout.top >= nextSize.layout.bottomPin

        noResultIcon.layout.make { make in
            make.square = 36
            make.centerX = 0
            make.top = navBar.layout.bottomPin + 146
        }

        noResultDescription.layout.make { make in
            make.width = min(280, layout.width - 108)
            make.centerX = 0
            make.top = noResultIcon.layout.bottomPin + 18
        }
    }
}
