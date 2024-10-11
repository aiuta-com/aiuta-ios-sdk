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

@_spi(Aiuta) import AiutaKit
import UIKit

extension OnBoardingView.StickyScroll {
    final class BestResultsSlide: Plane {
        let title = Label { it, ds in
            it.minScale = 0.75
            it.font = ds.font.titleL
            it.color = ds.color.primary
            it.text = L.onboardingBestResultsTitle
        }

        let description = Label { it, ds in
            it.isHtml = true
            it.isMultiline = true
            it.font = ds.font.regular
            it.color = ds.color.primary
            it.text = L.onboardingBestResultsDescription
        }

        let bestResults = BestResultsView { it, ds in
            if ds.config.appearance.reduceShadows {
                it.style = .flat
            }
        }

        override func updateLayout() {
            description.layout.make { make in
                make.left = 24
                make.right = 54
                make.bottom = 56
            }

            title.layout.make { make in
                make.bottom = description.layout.topPin + 16
                make.leftRight = 24
            }

            bestResults.layout.make { make in
                make.top = 30
                make.bottom = title.layout.topPin + 68
                make.leftRight = 57
                make.fit(.init(width: 284, height: 434))
                make.centerX = 0
            }
        }
    }

    enum Style {
        case aiuta, flat

        var size: CGFloat {
            switch self {
                case .aiuta: return 24
                case .flat: return 22
            }
        }

        var offset: CGFloat {
            switch self {
                case .aiuta: return 10
                case .flat: return 8
            }
        }

        var shadow: Float {
            switch self {
                case .aiuta: return 0.3
                case .flat: return 0
            }
        }
    }

    final class BestResultsView: Plane {
        var style: Style = .aiuta {
            didSet { updateStyle() }
        }

        let collage = CollageImage()
        let markers = MarkersView()

        override func setup() {
            updateStyle()
        }

        private func updateStyle() {
            markers.shadowOpacity = style.shadow
            markers.shadowRadius = style.offset
            updateLayout()
        }

        override func updateLayout() {
            collage.layout.make { make in
                make.inset = 0
                make.fit(.init(width: 238, height: 426))
            }

            markers.layout.make { make in
                make.frame = collage.layout.frame
            }

            layoutMarker(markers.mark1, relative: collage.image1)
            layoutMarker(markers.mark2, relative: collage.image2)
            layoutMarker(markers.mark3, relative: collage.image3)
            layoutMarker(markers.mark4, relative: collage.image4)
        }

        private func layoutMarker(_ marker: MarkerView, relative: Image) {
            marker.layout.make { make in
                make.circle = style.size
                make.left = relative.layout.left + style.offset
                make.top = relative.layout.top + style.offset
            }
        }

        convenience init(_ builder: (_ it: BestResultsView, _ ds: DesignSystem) -> Void) {
            self.init()
            builder(self, ds)
        }
    }

    final class CollageImage: Plane {
        let image1 = Image { it, ds in
            it.image = ds.image.onboarding(.best1)
        }

        let image2 = Image { it, ds in
            it.image = ds.image.onboarding(.best2)
        }

        let image3 = Image { it, ds in
            it.image = ds.image.onboarding(.best3)
        }

        let image4 = Image { it, ds in
            it.image = ds.image.onboarding(.best4)
        }

        override func updateLayout() {
            let w = (layout.width - 6) / 2
            let h = (layout.height - 6) / 2

            image1.layout.make { make in
                make.width = w
                make.height = h
                make.radius = ds.dimensions.imageBoardingRadius
            }

            image2.layout.make { make in
                make.width = w
                make.height = h
                make.right = 0
                make.radius = ds.dimensions.imageBoardingRadius
            }

            image3.layout.make { make in
                make.width = w
                make.height = h
                make.bottom = 0
                make.radius = ds.dimensions.imageBoardingRadius
            }

            image4.layout.make { make in
                make.width = w
                make.height = h
                make.bottom = 0
                make.right = 0
                make.radius = ds.dimensions.imageBoardingRadius
            }
        }
    }

    final class MarkersView: Shadow {
        let mark1 = MarkerView()
        let mark2 = MarkerView()
        let mark3 = MarkerView()
        let mark4 = MarkerView()

        override func setup() {
            shadowColor = .black
            shadowOffset = .zero

            mark1.icon.image = ds.image.icon24(.checkRounded)
            mark2.icon.image = ds.image.icon24(.checkRounded)
            mark3.icon.image = ds.image.icon24(.cross)
            mark4.icon.image = ds.image.icon24(.cross)

            mark1.color = ds.color.green
            mark2.color = ds.color.green
            mark3.color = ds.color.red
            mark4.color = ds.color.red
        }
    }

    final class MarkerView: Stroke {
        let icon = Image { it, ds in
            it.tint = ds.color.onDark
        }

        override func updateLayout() {
            icon.layout.make { make in
                make.center = .zero
            }
        }
    }
}
