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

final class AiutaTryOnView: Plane {
    let blur = Blur { it, _ in
        it.style = .extraLight
    }

    let resultView = AiutaTryOnResultView()

    let swipeEdge = SwipeEdge()
    let skuBar = AiutaSkuBar()
    let navBar = AiutaNavBar { it, _ in
        it.header.action.text = "History"
    }

    let photoSelector = AiutaPhotoSelector()
    let processingLoader = AiutaProcessingLoader()

    let poweredBy = AiutaPoweredButton()

    let sample = Image { it, _ in
        it.isAutoSize = false
    }

    let starter = AiutaProcessingStarter { it, _ in
        it.view.isVisible = false
    }

    let errorSnackbar = Snackbar<AiutaErrorSnackbar>()

    @bulletin
    var skuBulletin = AiutaSkuBulletin { it, _ in
        it.primaryButton.text = "Add to cart"
        it.secondaryButton.text = "Add to wishlist"
    }

    var mode: Aiuta.SessionState = .photoSelecting {
        didSet {
            guard oldValue != mode else { return }
            updateMode()
            animations.transition(.transitionCrossDissolve, duration: .quarterOfSecond)
        }
    }

    var hasSkuBar = true {
        didSet {
            guard oldValue != hasSkuBar else { return }
            if hasSkuBar { skuBar.animations.visibleTo(true) }
            animations.updateLayout { [self] in
                if !hasSkuBar { skuBar.animations.visibleTo(false) }
            }
        }
    }

    private func updateMode() {
        hasSkuBar = true
        switch mode {
            case .initial, .photoSelecting:
                photoSelector.view.isVisible = true
                processingLoader.view.isVisible = false
                resultView.view.isVisible = false
                poweredBy.view.isVisible = ds.config?.showPoweredByLink ?? true
                starter.view.isVisible = photoSelector.inputs.isSome
                resultView.data = nil
            case .processing:
                photoSelector.view.isVisible = false
                processingLoader.view.isVisible = true
                resultView.view.isVisible = false
                starter.view.isVisible = false
                poweredBy.view.isVisible = ds.config?.showPoweredByLink ?? true
            case .result:
                resultView.scrollView.scrollToTop(animated: false)
                resultView.isContinuationMode = false
                photoSelector.view.isVisible = false
                processingLoader.view.isVisible = false
                resultView.view.isVisible = true
                starter.view.isVisible = false
                poweredBy.view.isVisible = false
                resultView.updateLayout()
        }
    }

    override func setup() {
        updateMode()
    }

    override func updateLayout() {
        skuBar.layout.make { make in
            make.top = navBar.layout.bottomPin
            if !hasSkuBar {
                make.top -= make.height
            }
        }

        poweredBy.layout.make { make in
            make.centerX = 0
            make.bottom = layout.safe.insets.bottom + 24
        }

        photoSelector.layout.make { make in
            make.top = skuBar.layout.bottomPin + 24
            make.leftRight = 24
            make.bottom = poweredBy.layout.topPin + 42
            make.fit(.init(width: 9, height: 16))
        }

        processingLoader.layout.make { make in
            make.frame = photoSelector.layout.frame
        }

        resultView.layout.make { make in
            make.size = layout.size
        }

        resultView.topInset = navBar.layout.bottomPin + skuBar.layout.height

        sample.layout.make { make in
            make.circle = 5
            make.top = layout.height + 5
            make.centerX = 0
        }

        blur.layout.make { make in
            make.leftRight = 0
            make.top = skuBar.layout.bottomPin
            make.bottom = 0
        }
    }
}
