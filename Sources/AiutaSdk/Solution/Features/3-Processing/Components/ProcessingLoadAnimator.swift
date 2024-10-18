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
    final class LoadAnimator: Plane {
        let imageView = Image { it, _ in
            it.isAutoSize = true
            it.desiredQuality = .hiResImage
            it.contentMode = .scaleAspectFill
        }

        let border = Image { it, _ in
            it.desiredQuality = .hiResImage
            it.contentMode = .scaleAspectFill
            it.isAutoSize = false
            it.keepCurrentImage = true
            it.appearance.make { make in
                make.layer.shadowOffset = .zero
                make.layer.shadowRadius = 6
                make.layer.shadowOpacity = 1
                make.masksToBounds = false
            }
        }

        let overlay = Image { it, _ in
            it.desiredQuality = .hiResImage
            it.contentMode = .scaleAspectFill
            it.isAutoSize = false
            it.keepCurrentImage = true
        }

        let loaderContainer = Plane()

        let loader = ProcessingGradient { it, _ in
            it.view.isVisible = false
        }

        var isAnimating = false {
            didSet {
                guard oldValue != isAnimating else { return }
                loader.animations.visibleTo(isAnimating)
                if isAnimating { animateLoader() }
            }
        }

        private var isAnimationInProgress = false

        private var isLoaderOnTop = false {
            didSet {
                updateLayout()
                animateGhost()
            }
        }

        private let loaderDuration: TimeInterval = 3.5
        private let borderMask = CAGradientLayer()
        private var borderHeight: CGFloat = 100
        private var isFirst = true

        override func setup() {
            borderMask.colors = [UIColor.clear.cgColor, UIColor.white.cgColor,
                                 UIColor.white.cgColor, UIColor.clear.cgColor]
            borderMask.locations = [0, 0.3, 0.7, 1]
            border.view.layer.mask = borderMask
            border.view.layer.shadowColor = loader.stroke.color.cgColor
            loaderContainer.addContent(loader)
        }

        override func updateLayout() {
            imageView.layout.make { make in
                make.size = layout.bounds.size
                make.radius = view.cornerRadius
            }

            overlay.layout.make { make in
                make.frame = imageView.layout.frame
            }

            border.layout.make { make in
                make.frame = imageView.layout.frame
            }

            loaderContainer.layout.make { make in
                make.frame = layout.bounds
            }

            loader.layout.make { make in
                make.width = layout.width
                make.height = 190
                make.centerX = 0
                if isLoaderOnTop {
                    make.bottom = layout.height
                } else {
                    make.top = layout.height
                }
            }
        }

        private func animateGhost() {
            let borderOnTop: CGFloat = -loader.layout.height + borderHeight / 2
            let borderOnBottom: CGFloat = layout.height + borderHeight

            if isLoaderOnTop {
                border.view.isHidden = false
                CATransaction.setDisableActions(true)
                borderMask.position.y = borderOnTop
                let animation = CABasicAnimation(keyPath: "position.y")
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                animation.fromValue = borderOnBottom
                animation.toValue = borderOnTop
                animation.duration = loaderDuration + 0.5
                borderMask.add(animation, forKey: "Reposition")
            } else {
                border.view.isHidden = true
                borderMask.removeAllAnimations()
                borderMask.frame = .init(x: 0, y: borderOnBottom, width: layout.width, height: borderHeight)
                if overlay.image.isSome { loaderContainer.view.mask = overlay.view }
            }
        }

        private func animateLoader() {
            guard isAnimating else {
                loader.animations.visibleTo(false)
                return
            }

            guard !isAnimationInProgress else {
                return
            }

            isLoaderOnTop = false
            isAnimationInProgress = true
            animations.animate(delay: isFirst ? .thirdOfSecond : .halfOfSecond, time: .custom(loaderDuration)) { [weak self] in
                self?.isLoaderOnTop = true
            } complete: { [weak self] in
                self?.isAnimationInProgress = false
                self?.animateLoader()
            }
            isFirst = false
        }
    }

    final class ProcessingGradient: Plane {
        let gradient = Gradient { it, ds in
            it.direction = .vertical
            let colors = ds.color.loadingAnimation
            if colors.count == 3 {
                it.colorStops = [
                    .init(colors[0], 0),
                    .init(colors[1], 0.67),
                    .init(colors[2], 1),
                ]
            } else {
                it.colors = colors
            }
            it.view.maxOpacity = 0.5
        }

        let stroke = Stroke { it, ds in
            it.color = ds.color.loadingAnimation.first ?? ds.color.brand
        }

        override func updateLayout() {
            stroke.layout.make { make in
                make.leftRight = 0
                make.height = 2
            }

            gradient.layout.make { make in
                make.inset = 0
            }
        }
    }
}
