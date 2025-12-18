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

final class SizeFitBar: PlainButton {
    @injected private var sizeFit: Sdk.Core.SizeFit

    let strate = Stroke { it, ds in
        it.view.borderColor = ds.colors.border
        it.view.borderWidth = 1
    }

    let gradient = Gradient { it, _ in
        it.colorStops = [
            .init(UIColor(red: 0.421, green: 0.907, blue: 0.687, alpha: 1), 0.34),
            .init(UIColor(red: 0.272, green: 0.895, blue: 0.917, alpha: 1), 1),
        ]
        it.direction = .horizontal
    }

    let icon = Image { it, ds in
        it.isAutoSize = false
        it.source = ds.icons.sizeFit24
        it.tint = ds.colors.primary
    }

    let findSize = Label { it, ds in
        it.font = ds.fonts.subtle
        it.color = ds.colors.primary
        it.text = "Find your size"
    }

    let yourSize = Label { it, ds in
        it.font = ds.fonts.product
        it.color = ds.colors.secondary
    }

    let recommendedSize = Label { it, ds in
        it.font = ds.fonts.product
        it.color = ds.colors.primary
    }

    var product: Aiuta.Product? {
        didSet {
            guard oldValue != product else { return }
            recommendedSize.text = ""
            Task { await getRecommendedSize() }
        }
    }
    
    override func setup() {
        sizeFit.onChange.subscribe(with: self) { [unowned self] in
            invalidateLayout()
            Task { await getRecommendedSize() }
        }
    }

    override func updateLayout() {
        view.isVisible = sizeFit.isAvailable

        layout.make { make in
            guard sizeFit.isAvailable else {
                make.height = 0
                return
            }

            make.height = sizeFit.lastSurvey.isSome ? 22 : 48
        }

        if sizeFit.lastSurvey.isSome {
            strate.view.isVisible = false
            findSize.view.isVisible = false
            yourSize.view.isVisible = true
            recommendedSize.view.isVisible = true

            gradient.layout.make { make in
                make.square = 22
                make.left = 16
                make.centerY = 0
                make.radius = 6
            }

            icon.layout.make { make in
                make.square = 14
                make.center = gradient.layout.center
            }

            yourSize.layout.make { make in
                make.left = gradient.layout.rightPin + 8
                make.centerY = 0
            }

            recommendedSize.layout.make { make in
                make.left = yourSize.layout.rightPin + 5
                make.centerY = 0
            }
        } else {
            strate.view.isVisible = true
            findSize.view.isVisible = true
            yourSize.view.isVisible = false
            recommendedSize.view.isVisible = false

            strate.layout.make { make in
                make.leftRight = 16
                make.height = 48
                make.radius = 12
                make.centerY = 0
            }

            gradient.layout.make { make in
                make.circle = 32
                make.centerY = 0
                make.left = 28
            }

            icon.layout.make { make in
                make.square = 17
                make.center = gradient.layout.center
            }
            
            findSize.layout.make { make in
                make.left = gradient.layout.rightPin + 12
                make.centerY = 0
            }
        }
    }

    private func getRecommendedSize() async {
        guard let survey = sizeFit.lastSurvey, let product else { return }

        do {
            let recommendation = try await sizeFit.recommendation(survey: survey, product: product)
            yourSize.text = "Your size"
            recommendedSize.text = "\(recommendation.recommendedSizeName)"
        } catch {
            yourSize.text = "No size suggestion"
        }
    }
}
