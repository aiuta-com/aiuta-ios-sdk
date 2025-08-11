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

final class GalleryView: Pager<ImageSource, GalleryPage> {
    let onDismiss = Signal<Void>()

    let touchSwallow = Plane()
    
    let navigator = Navigator()

    let close = ImageButton { it, ds in
        it.image = ds.icons.close24
        it.tint = ds.colors.onDark
    }

    let share = LabelButton { it, ds in
        it.font = ds.fonts.buttonS
        it.label.color = ds.colors.onDark
        it.text = ds.strings.shareButton
    }

    let activity = ActivityIndicator { it, _ in
        it.hasDelay = true
        it.customLayout = true
    }

    var crossDissolve = true {
        didSet {
            touchSwallow.view.isVisible = crossDissolve
            navigator.view.isVisible = crossDissolve

            pages.forEach { page in
                if crossDissolve {
                    page.zoomView.zoomToFill()
                } else {
                    page.zoomView.zoomToFit()
                }
            }
        }
    }
    
    private var showsNavigator = true {
        didSet {
            guard showsNavigator != oldValue else { return }
            animations.updateLayout()
        }
    }

    override func setup() {
        gallerySpace = 20
        view.backgroundColor = .black

        activity.onActivity.subscribe(with: self) { [unowned self] loading in
            share.animations.visibleTo(!loading)
        }

        touchSwallow.gestures.onSwipe(.left, with: self) { [unowned self] swipe in
            guard swipe.state == .ended else { return }
            guard pageIndex < pageCount - 1 else { return }
            scroll(to: pageIndex + 1, crossDissolve: true)
        }

        touchSwallow.gestures.onSwipe(.right, with: self) { [unowned self] swipe in
            guard swipe.state == .ended else { return }
            guard pageIndex > 0 else { return }
            scroll(to: pageIndex - 1, crossDissolve: true)
        }

        touchSwallow.gestures.onSwipe(.up, with: self) { [unowned self] swipe in
            guard swipe.state == .ended else { return }
            guard pageIndex < pageCount - 1 else { return }
            scroll(to: pageIndex + 1, crossDissolve: true)
        }

        touchSwallow.gestures.onSwipe(.down, with: self) { [unowned self] swipe in
            guard swipe.state == .ended else { return }
            guard pageIndex > 0 else {
                onDismiss.fire()
                return
            }
            scroll(to: pageIndex - 1, crossDissolve: true)
        }

        touchSwallow.gestures.onPinch(with: self) { [unowned self] pinch in
            pages.forEach { page in
                if pinch.velocity > 0 {
                    page.zoomView.zoomToFill()
                } else {
                    page.zoomView.zoomToFit()
                }
            }
        }
        
        touchSwallow.gestures.onTap(with: self) { [unowned self] tap in
            guard tap.state == .ended else { return }
            showsNavigator.toggle()
        }
        
        onSwipePage.subscribe(with: self) { [unowned self] index in
            guard navigator.thumbnails.data.isSome else { return }
            navigator.selectedIndex = index
        }
        
        navigator.thumbnails.onTapItem.subscribe(with: self) { [unowned self] thumb in
            guard thumb.index.item != pageIndex else { return }
            scroll(to: thumb.index.item, crossDissolve: true)
        }

        pages.forEach { page in
            page.zoomView.zoomToFill()
        }
    }

    override func updateLayout() {
        touchSwallow.layout.make { make in
            make.inset = 0
        }

        close.layout.make { make in
            make.square = 44
            make.top = max(layout.safe.insets.top, 10) - 10
            make.left = 2
        }

        close.imageView.layout.make { make in
            make.square = 24
            make.center = .zero
        }

        share.layout.make { make in
            make.centerY = close.layout.centerY
            make.right = 16
        }

        activity.layout.make { make in
            make.frame = share.layout.frame
        }

        navigator.layout.make { make in
            make.width = 68
            make.top = close.layout.bottomPin + 8
            make.bottom = layout.safe.insets.bottom + 8
            make.left = showsNavigator ? 0 : -59.9
        }
        
        if navigator.thumbnails.data.isSome {
            navigator.selectedIndex = pageIndex
        }
    }
}
