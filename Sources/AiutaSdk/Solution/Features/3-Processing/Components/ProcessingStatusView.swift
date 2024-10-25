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

extension ProcessingView {
    final class ProcessingStatus: Plane {
        var text: String? {
            didSet {
                guard text != oldValue else { return }
                animations.visibleTo(text.isSomeAndNotEmpty)
                label.animations.opacityTo(0) { [weak self] in
                    guard let self else { return }
                    self.animations.animate { [self] in
                        self.label.text = self.text
                    } complete: { [weak self] in
                        guard let self else { return }
                        self.animations.visibleTo(self.text.isSomeAndNotEmpty)
                        self.label.animations.opacityTo(1)
                    }
                }
            }
        }

        private let blur = Blur { it, ds in
            it.style = ds.color.blur
            it.intensity = 0.4

            if ds.config.appearance.toggles.enableBlurOutlines {
                it.view.borderColor = ds.color.neutral3
                it.view.borderWidth = 1
            }
        }

        private let spin = Spinner { it, ds in
            if #available(iOS 13.0, *) {
                it.style = .medium
            }
            it.color = ds.color.primary
        }

        private let image = Image { it, ds in
            it.image = ds.image.icon14(.spin)
            if ds.config.appearance.toggles.enableBlurOutlines {
                it.tint = ds.color.onDark
            } else {
                it.tint = ds.color.primary
            }
        }

        private let label = Label { it, ds in
            it.isLineHeightMultipleEnabled = false
            it.font = ds.font.buttonS
            if ds.config.appearance.toggles.enableBlurOutlines {
                it.color = ds.color.onDark
            } else {
                it.color = ds.color.primary
            }
        }

        override func attached() {
            image.animations.rotate(duration: 1.5)
        }

        override func setup() {
            view.isVisible = false

            if image.image.isSome {
                spin.isSpinning = false
                spin.removeFromParent()
            }
        }

        override func updateLayout() {
            image.layout.make { make in
                make.circle = 14
                make.left = 24
            }

            spin.layout.make { make in
                make.center = image.layout.center
            }

            label.layout.make { make in
                if spin.isSpinning {
                    make.left = spin.layout.rightPin + 10
                } else {
                    make.left = image.layout.rightPin + 8
                }
            }

            layout.make { make in
                make.height = 40
                if label.hasText {
                    make.width = label.layout.rightPin + image.layout.left
                } else {
                    make.width = image.layout.rightPin + image.layout.left
                }
                make.centerX = 0
                make.radius = ds.dimensions.buttonSmallRadius
            }

            label.layout.make { make in
                make.centerY = 0
            }

            image.layout.make { make in
                make.centerY = 0
            }

            blur.layout.make { make in
                make.inset = 0
            }
        }
    }
}
