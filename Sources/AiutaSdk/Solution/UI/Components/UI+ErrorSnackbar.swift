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

final class ErrorSnackbar: Plane {
    let icon = CenterIcon()

    let label = Label { it, ds in
        it.font = ds.fonts.subtle
        it.color = ds.colors.errorPrimary
        it.isMultiline = true
        it.text = ds.strings.defaultErrorMessage
    }

    let tryAgain = LabelButton { it, ds in
        it.color = ds.colors.onDark
        it.font = ds.fonts.buttonS
        it.text = ds.strings.tryAgainButton
    }

    override func setup() {
        view.backgroundColor = ds.colors.errorBackground
    }

    override func updateLayout() {
        layout.make { make in
            make.height = 68
            make.shape = ds.shapes.buttonM
        }

        icon.layout.make { make in
            make.left = 16
            make.centerY = 0
        }

        tryAgain.layout.make { make in
            make.centerY = 0
            make.right = 16
            make.shape = ds.shapes.buttonS
        }

        label.layout.make { make in
            make.left = icon.layout.rightPin + 16
            make.right = tryAgain.layout.leftPin + 16
            make.centerY = -2
        }
    }

    final class CenterIcon: Plane {
        let icon = Image { it, ds in
            it.image = ds.icons.error36
            it.tint = ds.colors.errorPrimary
        }

        override func updateLayout() {
            layout.make { make in
                make.square = 36
            }

            icon.layout.make { make in
                make.square = 36
                make.center = .zero
            }
        }
    }
}
