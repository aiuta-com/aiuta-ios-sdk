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
final class ResultsView: Plane {
    let didBlackout = Signal<CGFloat>()

    let navBar = NavBar { it, ds in
        if ds.styles.preferCloseButtonOnTheRight {
            it.style = .actionTitleClose
        } else {
            it.style = .closeTitleAction
        }
        it.actionStyle = .icon(ds.icons.history24)
        it.title = ds.strings.tryOnPageTitle
    }

    let pager = Pager<Sdk.Core.TryOnResult, ResultPage> { it, _ in
        it.galleryInset = 100
    }

    let fitDisclaimer = FitDisclaimer()

    let blackout = PlainButton { it, _ in
        it.view.backgroundColor = .black.withAlphaComponent(0.5)
        it.view.isUserInteractionEnabled = false
    }

    let skuSheet = ProductSheet()
    
    @bulletin
    var productBulletin = Sdk.UI.Products.ProductBulletin { it, ds in
        it.wishButton.view.isVisible = ds.features.wishlist.isEnabled
    }

    var canBlackout = true {
        didSet {
            if !canBlackout {
                skuSheet.content.isEnabed = false
                skuSheet.content.opacity = 0.2
                skuSheet.content.shadowOpacity = 0
                blackout.view.opacity = 0
                didBlackout.fire(0)
            }
        }
    }

    override func setup() {
        skuSheet.didScroll.subscribe(with: self) { [unowned self] scroll in
            guard canBlackout else { return }

            blackout.view.isUserInteractionEnabled = !scroll.isAtTop
            let d = skuSheet.view.verticalOffsetForBottom - skuSheet.view.verticalOffsetForTop
            guard d > 0 else { return }
            let p = skuSheet.view.verticalOffsetForBottom - skuSheet.contentOffset.y
            let progress = clamp(1 - p / d, min: 0, max: 1)

            skuSheet.content.isEnabed = progress > 0.5
            skuSheet.content.opacity = 0.1 + 0.9 * progress
            skuSheet.content.shadowOpacity = Float(0.6 + 0.4 * progress)
            blackout.view.opacity = progress
            didBlackout.fire(progress)
        }

        blackout.onTouchDown.subscribe(with: self) { [unowned self] in
            skuSheet.scrollToTop()
        }

        blackout.gestures.onPan(.any, with: self) { pan in
            pan.cancel()
        }
    }

    override func updateLayout() {
        let isSheetOnBottom = skuSheet.view.isAtBottom

        pager.layout.make { make in
            make.leftRight = 0
            make.top = navBar.layout.bottomPin + 16
            make.bottom = layout.safe.insets.bottom + 169
        }

        skuSheet.layout.make { make in
            make.inset = 0
        }

        blackout.layout.make { make in
            make.inset = 0
        }

        fitDisclaimer.layout.make { make in
            make.top = pager.layout.bottomPin + 32
        }

        let sheetInsets = UIEdgeInsets(top: pager.layout.bottomPin + 57, bottom: layout.safe.insets.bottom)
        if sheetInsets != skuSheet.contentInset {
            if isSheetOnBottom {
                skuSheet.contentInset = sheetInsets
                skuSheet.scrollToBottom(animated: false)
            } else {
                skuSheet.keepOffset {
                    skuSheet.contentInset = sheetInsets
                }
            }
        }
    }
}
