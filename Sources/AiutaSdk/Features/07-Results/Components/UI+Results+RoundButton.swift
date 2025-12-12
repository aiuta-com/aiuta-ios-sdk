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

@available(iOS 13.0.0, *)
extension ResultPage {
    final class RoundButton: PlainButton {
        var hasBlur = true {
            didSet {
                blur.view.isVisible = hasBlur
                stroke.view.isVisible = !hasBlur
                stroke.color = hasBlur ? ds.colors.onDark.withAlphaComponent(0.05) : ds.colors.background
                icon.tint = (hasBlur && ds.colors.scheme == .light) ? ds.colors.onDark : ds.colors.primary
                activity.color = icon.tint
            }
        }

        let blur = Blur { it, ds in
            it.style = ds.colors.scheme.blurStyle
            it.intensity = 0.4

            if case .blurred(hasOutline: true) = ds.styles.loadingStatusStyle {
                it.view.borderColor = ds.colors.outline
                it.view.borderWidth = 1
            }
        }

        let stroke = Stroke { it, ds in
            it.color = ds.colors.onLight.withAlphaComponent(0.05)
        }

        let icon = Image { it, ds in
            it.isAutoSize = false
            it.tint = ds.colors.scheme == .light ? ds.colors.onDark : ds.colors.primary
        }

        let activity = ActivityIndicator { it, _ in
            it.hasDelay = true
        }

        override func setup() {
            activity.color = icon.tint
            activity.onActivity.subscribe(with: self) { [unowned self] loading in
                icon.animations.visibleTo(!loading)
            }
        }

        override func updateLayout() {
            layout.make { make in
                make.square = 54
            }

            blur.layout.make { make in
                make.circle = 38
                make.center = .zero
            }

            stroke.layout.make { make in
                make.circle = 38
                make.center = .zero
            }

            icon.layout.make { make in
                make.square = 24
                make.center = .zero
            }
        }

        convenience init(_ builder: (_ it: RoundButton, _ ds: DesignSystem) -> Void) {
            self.init()
            builder(self, ds)
        }
    }
}
