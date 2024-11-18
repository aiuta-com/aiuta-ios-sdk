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

final class DeleteAnimator: Stroke {
    var isAnimating = false {
        didSet {
            guard oldValue != isAnimating else { return }
            if isAnimating { startAnimation() }
            animations.updateLayout()
            animations.visibleTo(isAnimating) { [self] in
                if !isAnimating { stopAnimation() }
            }
        }
    }

    private let spin = Spinner { it, ds in
        if #available(iOS 13.0, *) {
            it.style = .medium
        }
        it.color = ds.color.onDark
        it.isSpinning = false
    }

    private let icon = Image { it, ds in
        it.image = ds.image.icon14(.spin)
        it.tint = ds.color.onDark
        it.contentMode = .scaleAspectFit
    }

    private func startAnimation() {
        if icon.hasImage {
            icon.animations.rotate(duration: 1.5)
        } else {
            spin.isSpinning = true
        }
    }

    private func stopAnimation() {
        if icon.hasImage {
            icon.view.layer.removeAllAnimations()
        } else {
            spin.isSpinning = false
        }
    }

    override func setup() {
        view.isVisible = false
        view.isUserInteractionEnabled = false
        color = .black.withAlphaComponent(0.5)
        if icon.image.isSome { spin.removeFromParent() }
    }

    override func updateLayout() {
        layout.make { make in
            make.inset = 0
            make.radius = ds.dimensions.imagePreviewRadius
        }

        icon.layout.make { make in
            make.circle = isAnimating ? 24 : 4
            make.center = .zero
        }

        spin.layout.make { make in
            make.center = .zero
        }
    }
}
