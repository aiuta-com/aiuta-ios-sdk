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

extension HistoryView {
    final class HistorySnack: Plane {
        let deleteButton = OptionButton { it, ds in
            it.icon.image = ds.image.icon24(.trash)
            it.view.isMaxOpaque = false
        }

        let shareButton = OptionButton { it, ds in
            it.icon.image = ds.image.icon24(.share)
            it.view.isMaxOpaque = false
        }

        let toggleSeletionButton = LabelButton { it, ds in
            it.font = ds.font.buttonS
            it.label.color = ds.color.ground
            it.text = L.historySelectorEnableButtonSelectAll
        }

        let cancelButton = LabelButton { it, ds in
            it.font = ds.font.buttonS
            it.color = ds.color.ground
            it.label.color = ds.color.primary
            it.text = L.cancel
        }

        override func setup() {
            view.backgroundColor = ds.color.primary
        }

        override func updateLayout() {
            layout.make { make in
                make.height = 68
                make.radius = ds.dimensions.buttonLargeRadius
            }

            cancelButton.layout.make { make in
                make.left = 16
                make.centerY = 0
                make.radius = ds.dimensions.buttonSmallRadius
            }

            toggleSeletionButton.layout.make { make in
                make.left = cancelButton.layout.rightPin + 10
                make.centerY = 0
            }

            shareButton.layout.make { make in
                make.right = 8
                make.centerY = 0
            }

            deleteButton.layout.make { make in
                make.right = shareButton.layout.leftPin
                make.centerY = 0
            }
        }
    }

    final class OptionButton: PlainButton {
        let circle = Stroke { it, ds in
            it.color = ds.color.ground
        }

        let icon = Image { it, ds in
            it.tint = ds.color.primary
        }

        var isEnabled = true {
            didSet {
                guard oldValue != isEnabled else { return }
                animations.opacityTo(isEnabled ? 1 : 0.6, time: .sixthOfSecond)
            }
        }

        override func setup() {
            view.minOpacity = 0.6
        }

        override func updateLayout() {
            layout.make { make in
                make.size = .init(square: 52)
            }

            circle.layout.make { make in
                make.circle = 36
                make.center = .zero
            }

            icon.layout.make { make in
                make.square = 24
                make.center = .zero
            }
        }

        convenience init(_ builder: (_ it: OptionButton, _ ds: DesignSystem) -> Void) {
            self.init()
            builder(self, ds)
        }
    }
}
