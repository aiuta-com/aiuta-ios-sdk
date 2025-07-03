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

final class ActivityIndicator: Plane {
    let onActivity = Signal<Bool>()

    var isAnimating = false {
        didSet {
            guard oldValue != isAnimating else { return }
            onActivity.fire(isAnimating)
            if isAnimating { startAnimation() }
            animations.updateLayout()
            animations.visibleTo(isAnimating) { [self] in
                if !isAnimating { stopAnimation() }
            }
        }
    }

    var hasOverlay = false
    var hasDelay = false
    var customLayout = false
    var color: UIColor? {
        didSet {
            icon.tint = color ?? ds.colors.onDark
            spin.color = color ?? ds.colors.onDark
        }
    }

    private var shouldStart = false

    func start() {
        shouldStart = true
        if hasDelay {
            delay(.custom(ds.styles.activityIndicatorDelay)) { [weak self] in
                guard let self, self.shouldStart else { return }
                self.isAnimating = true
            }
        } else {
            isAnimating = true
        }
    }

    func stop() {
        isAnimating = false
        shouldStart = false
    }

    private let spin = Spinner { it, _ in
        if #available(iOS 13.0, *) {
            it.style = .medium
        }
        it.isSpinning = false
    }

    private let icon = Image { it, ds in
        it.image = ds.icons.loading14
        it.contentMode = .scaleAspectFit
    }

    private func startAnimation() {
        if icon.hasImage {
            icon.animations.rotate(duration: ds.styles.activityIndicatorDuration)
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
        view.backgroundColor = hasOverlay ? ds.colors.activityOverlay : .clear
        if icon.image.isSome { spin.removeFromParent() }
        if color.isNil { color = ds.colors.onDark }
    }

    override func updateLayout() {
        if !customLayout {
            layout.make { make in
                make.inset = 0
                if hasOverlay {
                    make.shape = ds.shapes.imageM
                }
            }
        }

        icon.layout.make { make in
            make.circle = isAnimating ? 24 : 4
            make.center = .zero
        }

        spin.layout.make { make in
            make.center = .zero
        }
    }

    convenience init(_ builder: (_ it: ActivityIndicator, _ ds: DesignSystem) -> Void) {
        self.init()
        builder(self, ds)
    }
}
