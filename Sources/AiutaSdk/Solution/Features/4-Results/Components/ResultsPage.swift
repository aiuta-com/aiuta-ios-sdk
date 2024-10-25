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

final class ResultPage: Page<TryOnResult> {
    @injected private var session: SessionModel

    var hasFeedback = false {
        didSet {
            feedback.view.isVisible = hasFeedback
        }
    }

    let image = Image { it, _ in
        it.isAutoSize = false
        it.desiredQuality = .hiResImage
        it.contentMode = .scaleAspectFill
    }

    let shadowControls = ShadowControls()

    let feedback = FeedbackView { it, _ in
        it.view.isVisible = false
    }

    func updateWish() {
        let isInWhishlist = session.isInWishlist(data?.sku)
        shadowControls.wish.icon.image = ds.image.icon24(isInWhishlist ? .wishlistFill : .wishlist)
    }

    override func update(_ data: TryOnResult?) {
        image.source = data?.image
        updateWish()
    }

    override func update(_ position: Position) {
        animations.updateLayout()
        image.animations.opacityTo(position.isFocus ? 1 : 0.3)
        shadowControls.animations.visibleTo(position.isFocus)
        feedback.animations.visibleTo(position.isFocus && hasFeedback)
    }

    override func updateLayout() {
        image.layout.make { make in
            make.inset = position.isFocus ? 0 : 24
            make.radius = ds.dimensions.imageMainRadius
        }

        shadowControls.layout.make { make in
            make.inset = position.isFocus ? 0 : 20
            make.scale = position.isFocus ? 1 : 0.8
        }

        feedback.layout.make { make in
            make.bottom = image.layout.bottom + 4
            make.right = image.layout.right + 4
        }
    }

    final class ShadowControls: Shadow {
        let button = PlainButton()

        let newPhoto = RoundButton { it, ds in
            it.hasBlur = false
            it.icon.image = ds.image.icon24(.cameraSwap)
        }

        let share = RoundButton { it, ds in
            it.hasBlur = false
            it.icon.image = ds.image.icon24(.share)
        }

        let wish = RoundButton { it, ds in
            it.hasBlur = false
            it.icon.image = ds.image.icon24(.wishlist)
        }

        override func setup() {
            shadowOpacity = ds.config.appearance.toggles.reduceShadows ? 0 : 1
            shadowColor = .black.withAlphaComponent(0.08)
            shadowOffset = .zero
            shadowRadius = 30

            share.view.isVisible = ds.config.behavior.isShareAvailable
            wish.view.isVisible = ds.config.behavior.isWishlistAvailable
            newPhoto.view.isVisible = ds.config.behavior.allowContiniousTryOn
        }

        override func updateLayout() {
            button.layout.make { make in
                make.inset = 0
            }

            newPhoto.layout.make { make in
                make.bottom = 4
                make.left = 4
            }

            share.layout.make { make in
                make.right = 4
                make.top = 4
            }

            wish.layout.make { make in
                make.right = 4
                if share.view.isVisible {
                    make.top = share.layout.bottomPin - 8
                } else {
                    make.top = 4
                }
            }
        }
    }
}
