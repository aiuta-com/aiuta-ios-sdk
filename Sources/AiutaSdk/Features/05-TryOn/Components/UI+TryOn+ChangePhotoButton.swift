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
    final class ChangePhotoButton: PlainButton {
        let blur = Blur { it, ds in
            ds.styles.changePhotoButtonStyle.applyBlur(it)
            it.intensity = 0.5
        }

        let label = Label { it, ds in
            it.isLineHeightMultipleEnabled = false
            it.font = ds.fonts.buttonS
            it.color = ds.styles.changePhotoButtonStyle.foregroundColor
            it.text = ds.strings.uploadsHistoryButtonChangePhoto
        }

        override func setup() {
            view.backgroundColor = ds.styles.changePhotoButtonStyle.backgroundColor
        }

        override func updateLayout() {
            layout.make { make in
                make.width = label.layout.width + 48
                make.height = label.layout.height + 24
                make.shape = ds.shapes.buttonS
            }

            label.layout.make { make in
                make.center = .zero
            }

            blur.layout.make { make in
                make.inset = 0
                make.shape = ds.shapes.buttonS
            }
        }
    }
}
