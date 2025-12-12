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

extension Sdk.UI.TryOn {
    final class EmptyState: Plane {
        let area = Stroke { it, ds in
            it.color = ds.colors.neutral
        }

        let sample = Sample()

        let title = Label { it, ds in
            it.font = ds.fonts.titleM
            it.color = ds.colors.primary
            it.text = ds.strings.imagePickerTitle
        }

        let description = Label { it, ds in
            it.font = ds.fonts.subtle
            it.color = ds.colors.primary
            it.isMultiline = true
            it.alignment = .center
            it.text = ds.strings.imagePickerDescription
        }

        let uploadButton = LabelButton { it, ds in
            it.font = ds.fonts.buttonM
            it.color = ds.colors.brand
            it.label.color = ds.colors.onDark
            it.label.minScale = 0.5
            it.text = ds.strings.imagePickerButtonUploadPhoto
        }

        let orLabel = Label { it, ds in
            it.font = ds.fonts.regular
            it.color = ds.colors.primary
            it.text = ds.strings.predefinedModelsOr
            it.view.isVisible = ds.features.imagePicker.hasPredefinedModels
        }

        let chooseModelButton = LabelButton { it, ds in
            it.font = ds.fonts.buttonM
            it.color = ds.colors.onDark
            it.label.color = ds.colors.onLight
            it.label.minScale = 0.5
            it.text = ds.strings.predefinedModelsTitle
            it.view.isVisible = ds.features.imagePicker.hasPredefinedModels
        }

        let poweredBy = PoweredBy()

        override func updateLayout() {
            poweredBy.layout.make { make in
                make.centerX = 0
                make.bottom = layout.safe.insets.bottom + 16
            }

            area.layout.make { make in
                make.leftRight = 26
                make.top = 36
                make.bottom = poweredBy.layout.topPin + 38
                make.shape = ds.shapes.imageL
            }

            chooseModelButton.layout.make { make in
                make.height = 50
                make.width = 240
                make.centerX = 0
                make.bottom = area.layout.bottom + 33
                make.shape = ds.shapes.buttonM
            }

            orLabel.layout.make { make in
                make.centerX = 0
                make.bottom = chooseModelButton.layout.topPin + 20
            }

            uploadButton.layout.make { make in
                make.height = 50
                make.width = 240
                make.centerX = 0
                if chooseModelButton.view.isVisible {
                    make.bottom = orLabel.layout.topPin + 20
                } else {
                    make.bottom = area.layout.bottom + 102
                }
                make.shape = ds.shapes.buttonM
            }

            description.layout.make { make in
                make.leftRight = 40 + area.layout.left
                make.bottom = uploadButton.layout.topPin + 32
            }

            title.layout.make { make in
                make.centerX = 0
                make.bottom = description.layout.topPin + 16
            }

            sample.layout.make { make in
                make.top = area.layout.top + 57
                make.bottom = title.layout.topPin + 30
            }
        }
    }
}

extension Sdk.UI.TryOn.EmptyState {
    final class Sample: Shadow {
        let image2 = ShadowImage { it, ds in
            it.imageView.image = ds.images.imagePickerExamples[safe: 0]
        }

        let image1 = ShadowImage { it, ds in
            it.imageView.image = ds.images.imagePickerExamples[safe: 1]
        }

        override func setup() {
            shadowColor = ds.colors.primary.withAlphaComponent(0.1)
            shadowOpacity = 1
            shadowRadius = 19
            shadowOffset = .init(width: 0, height: 30)
        }

        override func updateLayout() {
            layout.make { make in
                make.width = 262
                make.centerX = 0
            }

            image2.layout.make { make in
                make.width = 96
                make.height = 155
                make.centerX = 38
                make.centerY = 0
                make.rotation = 12
            }

            image1.layout.make { make in
                make.width = 96
                make.height = 155
                make.centerX = -38
                make.centerY = 0
                make.rotation = -10
            }
        }
    }

    final class ShadowImage: Shadow {
        let imageView = Image { it, ds in
            it.isAutoSize = false
            it.contentMode = .scaleAspectFill
            it.view.borderColor = ds.colors.onDark
            it.view.borderWidth = 4
        }

        override func setup() {
            shadowColor = ds.colors.primary.withAlphaComponent(0.06)
            shadowOpacity = 1
            shadowRadius = 7.83
            shadowOffset = .init(width: 0, height: 3.36)
        }

        override func updateLayout() {
            imageView.layout.make { make in
                make.inset = 0
                make.shape = ds.shapes.imageM
            }
        }

        convenience init(_ builder: (_ it: ShadowImage, _ ds: DesignSystem) -> Void) {
            self.init()
            builder(self, ds)
        }
    }
}
